require "byebug"
class TicketField
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
  your_ticket = parser.your_ticket
  nearby_tickets = parser.nearby_tickets

  scanner = TicketScanner.new(ticket_fields)
  error_rate = scanner.error_rate(nearby_tickets)

  puts "The error rate for nearby tickets is #{error_rate}"
end
