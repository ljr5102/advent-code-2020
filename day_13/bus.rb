class Bus
  attr_reader :id, :depart_after_increment

  def initialize(id, depart_after_increment = 0)
    @id = id
    @depart_after_increment = depart_after_increment
  end

  def departs_at?(time)
    (time % id).zero?
  end

  def valid_time?(time)
    departs_at?(time + depart_after_increment)
  end
end

def find_departure_bus(start_time, buses)
  time = nil
  bus = nil

  until bus
    time = time.nil? ? start_time : time + 1
    bus = buses.find { |bus| bus.departs_at?(time) }
  end

  { time: time, bus: bus.id }
end

def find_time_of_subsequent_departures(buses)
  stuff =buses.map do |bus|
    desired_mod = (bus.id - bus.depart_after_increment) % bus.id
    adder = bus.id
    { desired_mod: desired_mod, adder: adder }
  end.sort_by { |bus| bus[:desired_mod] }.reverse

  start = stuff.first[:desired_mod]
  adder = stuff.first[:adder]
  stuff.drop(1).each do |config|
    until start % config[:adder] == config[:desired_mod]
      start += adder
    end
    adder = adder * config[:adder]
  end

  start
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt")
  start_time = input.first.to_i
  buses = input.last.split(",").map(&:to_i).map.with_index { |id, idx| Bus.new(id, idx) }
  buses = buses.reject { |bus| bus.id.zero? }

  departure = find_departure_bus(start_time, buses)
  time = departure[:time]
  bus_id = departure[:bus]
  wait = time - start_time
  product = wait * bus_id
  puts "The earliest time to leave is #{time} on bus id #{bus_id} for a wait time of #{wait} minutes and a product of #{product}"

  t = find_time_of_subsequent_departures(buses)
  puts "The earliest timestamp that all of the listed bus IDs depart at offsets matching their positions in the list is #{t}"
end
