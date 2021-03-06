class Cube
  NEIGHBOR_INCREMENTS = [
    [0, 0, 1],
    [0, 0, -1],
    [0, 1, 0],
    [0, 1, 1],
    [0, 1, -1],
    [0, -1, 0],
    [0, -1, 1],
    [0, -1, -1],
    [1, 0, 0],
    [1, 0, 1],
    [1, 0, -1],
    [1, 1, 0],
    [1, 1, 1],
    [1, 1, -1],
    [1, -1, 0],
    [1, -1, 1],
    [1, -1, -1],
    [-1, 0, 0],
    [-1, 0, 1],
    [-1, 0, -1],
    [-1, 1, 0],
    [-1, 1, 1],
    [-1, 1, -1],
    [-1, -1, 0],
    [-1, -1, 1],
    [-1, -1, -1],
  ]

  attr_reader :x, :y, :z, :state, :flagged

  def initialize(x, y, z, state)
    @x = x
    @y = y
    @z = z
    @state = state
    @flagged = false
  end

  def active?
    state == "#"
  end

  def flag
    @flagged = true
  end

  def flip
    return unless flagged

    @state = active? ? "." : "#"
    @flagged = false
  end

  def neighbor_coords
    @neighbor_coords ||= NEIGHBOR_INCREMENTS.map do |(x_inc, y_inc, z_inc)|
      [x + x_inc, y + y_inc, z + z_inc]
    end
  end
end

class HyperCube
  NEIGHBOR_INCREMENTS = [
    [0, 0, 0, 1],
    [0, 0, 0, -1],
    [0, 0, 1, 0],
    [0, 0, 1, 1],
    [0, 0, 1, -1],
    [0, 0, -1, 0],
    [0, 0, -1, 1],
    [0, 0, -1, -1],
    [0, 1, 0, 0],
    [0, 1, 0, 1],
    [0, 1, 0, -1],
    [0, 1, 1, 0],
    [0, 1, 1, 1],
    [0, 1, 1, -1],
    [0, 1, -1, 0],
    [0, 1, -1, 1],
    [0, 1, -1, -1],
    [0, -1, 0, 0],
    [0, -1, 0, 1],
    [0, -1, 0, -1],
    [0, -1, 1, 0],
    [0, -1, 1, 1],
    [0, -1, 1, -1],
    [0, -1, -1, 0],
    [0, -1, -1, 1],
    [0, -1, -1, -1],
    [1, 0, 0, 0],
    [1, 0, 0, 1],
    [1, 0, 0, -1],
    [1, 0, 1, 0],
    [1, 0, 1, 1],
    [1, 0, 1, -1],
    [1, 0, -1, 0],
    [1, 0, -1, 1],
    [1, 0, -1, -1],
    [1, 1, 0, 0],
    [1, 1, 0, 1],
    [1, 1, 0, -1],
    [1, 1, 1, 0],
    [1, 1, 1, 1],
    [1, 1, 1, -1],
    [1, 1, -1, 0],
    [1, 1, -1, 1],
    [1, 1, -1, -1],
    [1, -1, 0, 0],
    [1, -1, 0, 1],
    [1, -1, 0, -1],
    [1, -1, 1, 0],
    [1, -1, 1, 1],
    [1, -1, 1, -1],
    [1, -1, -1, 0],
    [1, -1, -1, 1],
    [1, -1, -1, -1],
    [-1, 0, 0, 0],
    [-1, 0, 0, 1],
    [-1, 0, 0, -1],
    [-1, 0, 1, 0],
    [-1, 0, 1, 1],
    [-1, 0, 1, -1],
    [-1, 0, -1, 0],
    [-1, 0, -1, 1],
    [-1, 0, -1, -1],
    [-1, 1, 0, 0],
    [-1, 1, 0, 1],
    [-1, 1, 0, -1],
    [-1, 1, 1, 0],
    [-1, 1, 1, 1],
    [-1, 1, 1, -1],
    [-1, 1, -1, 0],
    [-1, 1, -1, 1],
    [-1, 1, -1, -1],
    [-1, -1, 0, 0],
    [-1, -1, 0, 1],
    [-1, -1, 0, -1],
    [-1, -1, 1, 0],
    [-1, -1, 1, 1],
    [-1, -1, 1, -1],
    [-1, -1, -1, 0],
    [-1, -1, -1, 1],
    [-1, -1, -1, -1]
  ]
  attr_reader :x, :y, :z, :w, :state, :flagged

  def initialize(x, y, z, w, state)
    @x = x
    @y = y
    @z = z
    @w = w
    @state = state
    @flagged = false
  end

  def active?
    state == "#"
  end

  def flag
    @flagged = true
  end

  def flip
    return unless flagged

    @state = active? ? "." : "#"
    @flagged = false
  end

  def neighbor_coords
    @neighbor_coords ||= NEIGHBOR_INCREMENTS.map do |(x_inc, y_inc, z_inc, w_inc)|
      [x + x_inc, y + y_inc, z + z_inc, w + w_inc]
    end
  end
end

class Grid
  attr_reader :hash

  def self.setup(input)
    obj = new
    input.each_with_index do |row, y_idx|
      row.each_with_index do |val, x_idx|
        obj.add_cube(x_idx, y_idx, 0, val)
      end
    end
    obj
  end

  def initialize
    @hash = {}
  end

  def all_cubes
    hash.values
  end

  def add_cube(x_idx, y_idx, z_idx, state)
    key = "#{x_idx}#{y_idx}#{z_idx}"
    if hash[key]
      raise "hmm seems like there's a cube at #{key} already..."
    end
    hash[key] = Cube.new(x_idx, y_idx, z_idx, state)
  end

  def cube_at(x, y, z)
    key = "#{x}#{y}#{z}"
    if !hash[key]
      add_cube(x, y, z, ".")
    end
    hash[key]
  end
end

class HyperGrid
  attr_reader :hash

  def self.setup(input)
    obj = new
    input.each_with_index do |row, y_idx|
      row.each_with_index do |val, x_idx|
        obj.add_cube(x_idx, y_idx, 0, 0, val)
      end
    end
    obj
  end

  def initialize
    @hash = {}
  end

  def all_cubes
    hash.values
  end

  def add_cube(x_idx, y_idx, z_idx, w_idx, state)
    key = "#{x_idx}#{y_idx}#{z_idx}#{w_idx}"
    if hash[key]
      raise "hmm seems like there's a cube at #{key} already..."
    end
    hash[key] = HyperCube.new(x_idx, y_idx, z_idx, w_idx, state)
  end

  def cube_at(x, y, z, w)
    key = "#{x}#{y}#{z}#{w}"
    if !hash[key]
      add_cube(x, y, z, w, ".")
    end
    hash[key]
  end
end

class Cycle
  attr_reader :grid

  def initialize(grid)
    @grid = grid
  end

  def run
    puts "Running Cycle"
    grid.all_cubes.each do |cube|
      neighbors = cube.neighbor_coords.map { |(x, y, z)| grid.cube_at(x, y, z) }
      ([cube] + neighbors).each do |cube|
        neighbors = cube.neighbor_coords.map { |(x, y, z)| grid.cube_at(x, y, z) }
        if cube.active?
          cube.flag unless (2..3).include?(neighbors.count(&:active?))
        else
          cube.flag if neighbors.count(&:active?) == 3
        end
      end
    end
    grid.all_cubes.map(&:flip)
  end
end

class HyperCycle
  attr_reader :grid

  def initialize(grid)
    @grid = grid
  end

  def run(num)
    puts "Running HyperCycle #{num}"

    length = grid.all_cubes.length
    grid.all_cubes.each_with_index do |cube, idx|
      puts "On Cube #{idx + 1} of #{length} "
      neighbors = cube.neighbor_coords.map { |(x, y, z, w)| grid.cube_at(x, y, z, w) }
      ([cube] + neighbors).each do |cube|
        neighbors = cube.neighbor_coords.map { |(x, y, z, w)| grid.cube_at(x, y, z, w) }
        if cube.active?
          cube.flag unless (2..3).include?(neighbors.count(&:active?))
        else
          cube.flag if neighbors.count(&:active?) == 3
        end
      end
    end
    grid.all_cubes.map(&:flip)
  end
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map { |row| row.strip.split("") }

  grid = Grid.setup(input)

  6.times do
    cycle = Cycle.new(grid)
    cycle.run
  end
  puts "Number of active cubes are #{grid.all_cubes.count(&:active?)}" # 268 is too low 272 is too high

  grid = HyperGrid.setup(input)

  6.times do |i|
    cycle = HyperCycle.new(grid)
    cycle.run(i + 1)
  end
  puts "Number of active cubes are #{grid.all_cubes.count(&:active?)}"
end
