class Grid
  def self.populate_grid(input)
    grid = new
    input.each do |row|
      grid.append(row)
    end
    grid
  end

  def initialize
    @map = []
  end

  def [](x, y)
    raise "hell" if invalid_spot?(x, y)

    map[y][x % x_length]
  end

  def invalid_spot?(x, y)
    x.negative? || y.negative? || y >= y_length
  end

  def append(row)
    map << row
  end

  private

  def x_length
    (map[0] || []).length
  end

  def y_length
    map.length
  end

  attr_reader :map
end

class Spot
  def initialize(value)
    raise "invalid value: #{value}" unless [".", "#"].include?(value)
    @value = value
  end

  def obstacle?
    value == "#"
  end

  private

  attr_reader :value
end

def count_trees_in_traversal(grid)
  x = 0
  y = 0
  trees = 0

  until grid.invalid_spot?(x, y)
    trees += 1 if grid[x, y].obstacle?
    x += 3
    y += 1
  end
  trees
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:strip)
  formatted = input.map do |row|
    row.split("").map { |value| Spot.new(value) }
  end
  grid = Grid.populate_grid(formatted)

  puts "Trees in traversal: #{count_trees_in_traversal(grid)}"
end
