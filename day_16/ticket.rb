class TicketField
  attr_reader :name

  def initialize(name, ranges)
    @name = name
    @ranges = ranges
  end

  def valid?(value)
    ranges.any? { |range| range.include?(value) }
  end

  private

  attr_reader :ranges
end

class TicketFieldParser
  def initialize(input)
    @input = input
  end

  def parse
    input.map do |el|
      raw_name, range_text = el.split(": ")
      name = raw_name.gsub(" ", "_").to_sym
      ranges = range_text.split(" or ").map do |rng|
        low, high = rng.split("-")
        (low.to_i..high.to_i)
      end
      TicketField.new(name, ranges)
    end
  end

  private

  attr_reader :input
end

class TicketScanner
  def initialize(fields)
    @fields = fields
  end

  def error_rate(tickets)
    tickets.sum do |ticket|
      invalid_vals = ticket.reject do |num|
        fields.any? { |field| field.valid?(num) }
      end
      invalid_vals.sum
    end
  end

  def ordered_fields(tickets)
    valid_tickets = tickets.reject do |ticket|
      ticket.any? do |num|
        fields.none? { |field| field.valid?(num) }
      end
    end

    potential_fields = {}

    fields.length.times do |idx|
      idx_vals = valid_tickets.map { |ticket| ticket[idx] }
      idx_fields = fields.select do |field|
        idx_vals.all? { |val| field.valid?(val) }
      end
      if idx_fields.empty?
        raise "hell"
      end
      potential_fields[idx] = idx_fields.map(&:name)
    end

    ordered = {}

    until ordered.keys.length == potential_fields.keys.length
      potential_fields.keys.each do |idx|
        if potential_fields[idx].length == 1
          ordered[idx] = potential_fields[idx].first
          potential_fields.values.each { |val| val.delete_if { |el| el == ordered[idx] } }
        end
      end
    end

    ordered

  end

  attr_reader :fields
end

class TicketParser
  def initialize(input)
    @input = input
  end

  def parse
    input.map { |vals| vals.split(",").map(&:to_i) }
  end

  attr_reader :input
end

class RawInputParser
  attr_reader :ticket_fields, :your_ticket, :nearby_tickets

  def initialize(input)
    @input = input.map(&:strip).reject(&:empty?)
  end

  def parse
    field_parser_inputs = []
    your_ticket_parser_inputs = []
    nearby_ticket_parser_inputs = []
    current_parser_inputs = field_parser_inputs

    input.each do |el|
      if el == "your ticket:"
        current_parser_inputs = your_ticket_parser_inputs
        next
      elsif el == "nearby tickets:"
        current_parser_inputs = nearby_ticket_parser_inputs
        next
      else
        current_parser_inputs << el
      end
    end

    @ticket_fields = TicketFieldParser.new(field_parser_inputs).parse
    @your_ticket = TicketParser.new(your_ticket_parser_inputs).parse
    @nearby_tickets = TicketParser.new(nearby_ticket_parser_inputs).parse
  end

  private

  attr_reader :input
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt")
  parser = RawInputParser.new(input)
  parser.parse

  ticket_fields = parser.ticket_fields
  your_ticket = parser.your_ticket.first
  nearby_tickets = parser.nearby_tickets

  scanner = TicketScanner.new(ticket_fields)
  error_rate = scanner.error_rate(nearby_tickets)
  ordered = scanner.ordered_fields(nearby_tickets)
  departure_field_indexes = ordered.keys.select { |key| ordered[key].to_s.start_with?("departure_") }
  departure_product = departure_field_indexes.inject(1) { |acc, el| acc * your_ticket[el] }

  puts "The error rate for nearby tickets is #{error_rate}"
  puts "The product of the departure fields on your ticket is #{departure_product}"
end
