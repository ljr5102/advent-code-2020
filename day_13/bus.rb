class Bus
  attr_reader :id

  def initialize(id)
    @id = id
  end

  def departs_at?(time)
    (time % id).zero?
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

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt")
  start_time = input.first.to_i
  buses = input.last.split(",").map(&:to_i).reject(&:zero?).map { |id| Bus.new(id) }

  departure = find_departure_bus(start_time, buses)
  time = departure[:time]
  bus_id = departure[:bus]
  wait = time - start_time
  product = wait * bus_id
  puts "The earliest time to leave is #{time} on bus id #{bus_id} for a wait time of #{wait} minutes and a product of #{product}"
end
