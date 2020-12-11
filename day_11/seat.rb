class Grid
  def self.setup(input)
    grid = input.map.with_index do |el, first_idx|
      el.split("").map.with_index do |el_two, second_idx|
        if el_two == "."
          Floor.new(position: [first_idx, second_idx], state: el_two)
        elsif el_two == "L" || el_two == "#"
          Seat.new(position: [first_idx, second_idx], state: el_two)
        else
          raise "hell"
        end
      end
    end
    new(grid)
  end

  def initialize(grid)
    @grid = grid
  end

  def [](idx_one, idx_two)
    return nil unless (0...grid.length).include?(idx_one) && (0...grid[0].length).include?(idx_two)
    grid[idx_one][idx_two]
  end

  attr_reader :grid
end

class GridPosition
  NEIGHBOR_INCREMENTS = [
    [-1, -1], [-1, 0], [-1, 1],
    [0, -1], [0, 1],
    [1, -1], [1, 0], [1, 1],
  ]

  def initialize(position:, state:)
    @position = position
    @state = state
  end

  def neighbors(grid)
    NEIGHBOR_INCREMENTS.map do |pos|
      grid[position.first + pos.first, position.last + pos.last]
    end.compact
  end

  def extended_neighbors(grid)
    all = []
    NEIGHBOR_INCREMENTS.each do |(first_inc, second_inc)|
      neighb_idx = [position.first + first_inc, position.last + second_inc]
      neighb = grid[*neighb_idx]
      until neighb.nil?
        all << neighb if neighb.seat?
        break if neighb.seat?
        neighb_idx = [neighb_idx.first + first_inc, neighb_idx.last + second_inc]
        neighb = grid[*neighb_idx]
      end
    end
    all
  end

  def occupied?
    raise NotImplemented
  end

  def name
    raise NotImplemented
  end

  def seat?
    false
  end

  def to_s
    state
  end

  private

  attr_reader :position, :should_flip
  attr_accessor :state
end

class Floor < GridPosition
  def occupied?
    false
  end

  def mark_to_flip; end
  def flip; end

  def should_flip?
    false
  end
end

class Seat < GridPosition
  def occupied?
    state == "#"
  end

  def seat?
    true
  end

  def flip
    return unless should_flip?
    if state == "#"
      self.state = "L"
    elsif state == "L"
      self.state = "#"
    else
      raise "hell"
    end
    @should_flip = false
  end

  def should_flip?
    should_flip
  end

  def mark_to_flip
    @should_flip = true
  end
end

class Round
  def initialize(grid)
    @grid = grid
  end

  def cycle_to_stable
    prev_round = grid.grid.flatten.map(&:to_s).join("")
    curr_round = nil
    until prev_round == curr_round
      cycle_once
      prev_round = curr_round
      curr_round = grid.grid.flatten.map(&:to_s).join("")
    end
  end

  def cycle_once
    grid.grid.flatten.select(&:seat?).each do |seat|
      if seat.occupied?
        seat.mark_to_flip if seat.neighbors(grid).count(&:occupied?) >= 4
      else
        seat.mark_to_flip if seat.neighbors(grid).count(&:occupied?).zero?
      end
    end
    grid.grid.flatten.each(&:flip)
  end

  attr_reader :grid
end

class ExtendedRound
  def initialize(grid)
    @grid = grid
  end

  def cycle_to_stable
    prev_round = grid.grid.flatten.map(&:to_s).join("")
    curr_round = nil
    until prev_round == curr_round
      cycle_once
      prev_round = curr_round
      curr_round = grid.grid.flatten.map(&:to_s).join("")

    end
  end

  def cycle_once
    grid.grid.flatten.select(&:seat?).each do |seat|
      if seat.occupied?
        seat.mark_to_flip if seat.extended_neighbors(grid).count(&:occupied?) >= 5
      else
        seat.mark_to_flip if seat.extended_neighbors(grid).count(&:occupied?).zero?
      end
    end
    grid.grid.flatten.each(&:flip)
  end

  attr_reader :grid
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:strip)

  grid = Grid.setup(input)
  Round.new(grid).cycle_to_stable
  puts "After cycling to stabilization, there are #{grid.grid.flatten.count(&:occupied?)} seats occupied."

  grid = Grid.setup(input)
  ExtendedRound.new(grid).cycle_to_stable
  puts "After cycling to stabilization, there are #{grid.grid.flatten.count(&:occupied?)} seats occupied."
end
