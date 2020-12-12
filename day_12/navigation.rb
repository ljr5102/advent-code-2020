class Ship
  attr_reader :x_value, :y_value, :dir

  DIRECTION_VALUE_MAP = {
    N: { x: 0, y: 1 },
    S: { x: 0, y: -1 },
    E: { x: 1, y: 0 },
    W: { x: -1, y: 0 },
  }

  DIRECTION_ACTION_MAP = {
    F: :move_current,
    N: :move_direction,
    S: :move_direction,
    E: :move_direction,
    W: :move_direction,
    R: :turn,
    L: :turn,
  }

  DIRECTION_MAP = {
    N: 0,
    E: 90,
    S: 180,
    W: 270,
  }

  DIRECTION_REVERSE_MAP = {
    "0" => :N,
    "90" => :E,
    "180" => :S,
    "270" => :W,
  }

  TURN_MAP = {
    L: -1,
    R: 1,
  }

  def initialize
    @dir = :E
    @x_value = 0
    @y_value = 0
  end

  def navigate(dir, val)
    send(DIRECTION_ACTION_MAP[dir], direction: dir, value: val)
  end

  def navigate_to_waypoint(val, waypoint)
    @x_value += val * waypoint.x_value
    @y_value += val * waypoint.y_value
  end

  def manhattan_distance
    x_value.abs + y_value.abs
  end

  private

  def move_direction(direction:, value:)
    @x_value += value * DIRECTION_VALUE_MAP[direction][:x]
    @y_value += value * DIRECTION_VALUE_MAP[direction][:y]
  end

  def move_current(direction:, value:)
    @x_value += value * DIRECTION_VALUE_MAP[dir][:x]
    @y_value += value * DIRECTION_VALUE_MAP[dir][:y]
  end

  def turn(direction:, value:)
    @dir = DIRECTION_REVERSE_MAP[((DIRECTION_MAP[dir] + (value * TURN_MAP[direction])) % 360).to_s]
  end
end

class Waypoint
  attr_accessor :x_value, :y_value

  DIRECTION_ACTION_MAP = {
    N: :move_direction,
    S: :move_direction,
    E: :move_direction,
    W: :move_direction,
    R: :rotate,
    L: :rotate,
  }

  DIRECTION_VALUE_MAP = {
    N: { x: 0, y: 1 },
    S: { x: 0, y: -1 },
    E: { x: 1, y: 0 },
    W: { x: -1, y: 0 },
  }

  def initialize
    @x_value = 10
    @y_value = 1
  end

  def move(dir, val)
    send(DIRECTION_ACTION_MAP[dir], direction: dir, value: val)
  end

  private

  def move_direction(direction:, value:)
    @x_value += value * DIRECTION_VALUE_MAP[direction][:x]
    @y_value += value * DIRECTION_VALUE_MAP[direction][:y]
  end

  def rotate(direction:, value:)


    @x_value, @y_value = {
      L: {
        "0" => [x_value, y_value],
        "90" => [-y_value, x_value],
        "180" => [-x_value, -y_value],
        "270" => [y_value, -x_value],
      },
      R: {
        "0" => [x_value, y_value],
        "90" => [y_value, -x_value],
        "180" => [-x_value, -y_value],
        "270" => [-y_value, x_value],
      },
    }[direction][(value % 360).to_s]
  end
end

class Dispatcher
  def initialize(ship, waypoint, instructions)
    @ship = ship
    @waypoint = waypoint
    @instructions = instructions
  end

  def dispatch
    instructions.each do |instruction|
      ship.navigate_to_waypoint(instruction[:value], waypoint) if ship_instruction?(instruction)
      waypoint.move(instruction[:direction], instruction[:value]) if waypoint_instruction?(instruction)
    end
  end

  private

  def ship_instruction?(instruction)
    instruction[:direction] == :F
  end

  def waypoint_instruction?(instruction)
    [:N, :S, :E, :W, :L, :R].include?(instruction[:direction])
  end

  attr_reader :ship, :waypoint, :instructions
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt")
  formatted = input.map do |el|
    val = el.strip
    { direction: val[0].to_sym, value: val[1..].to_i }
  end

  ship = Ship.new
  formatted.each do |nav|
    ship.navigate(nav[:direction], nav[:value])
  end

  puts "After moving from ship-only instructions, the ships manhattan distance is #{ship.manhattan_distance}"

  ship = Ship.new
  waypoint = Waypoint.new
  Dispatcher.new(ship, waypoint, formatted).dispatch

  puts "After moving from waypoint instructions, the ships manhattan distance is #{ship.manhattan_distance}"
end
