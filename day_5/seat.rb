class SeatFinder
  attr_reader :row, :column

  MINIMUM_ROW = 0
  MAXIMUM_ROW = 127
  MINIMUM_COLUMN = 0
  MAXIMUM_COLUMN = 7

  def initialize(input)
    @input = input
    @row_lower = MINIMUM_ROW
    @row_upper = MAXIMUM_ROW
    @column_lower = MINIMUM_COLUMN
    @column_upper = MAXIMUM_COLUMN
  end

  def find
    input.each_char do |char|
      if char == "F"
        @row_upper = row_upper - ((row_upper - row_lower + 1) / 2)
      elsif char == "B"
        @row_lower = row_lower + ((row_upper - row_lower + 1) / 2)
      elsif char == "L"
        @column_upper = column_upper - ((column_upper - column_lower + 1) / 2)
      elsif char == "R"
        @column_lower = column_lower + ((column_upper - column_lower + 1) / 2)
      else
        raise "hell"
      end
    end
    raise "hell" unless row_upper == row_lower && column_upper == column_lower
    @row = row_lower
    @column = column_lower
  end

  private

  attr_reader :input, :row_lower, :row_upper, :column_lower, :column_upper
end

def seat_id(row, column)
  row * 8 + column
end

def find_my_seat(configs)
  all_seats = Array.new(128) { Array.new(8) }

  configs.each do |config|
    all_seats[config[:row]][config[:column]] = "X"
  end

  potential_seats = []

  all_seats.each_index do |row_idx|
    all_seats[row_idx].each_index do |col_idx|
      if all_seats[row_idx][col_idx].nil?
        seat_id = seat_id(row_idx, col_idx)
        neighbors_full = [seat_id - 1, seat_id + 1].all? { |id| configs.any? { |config| config[:seat_id] == id } }
        potential_seats << { seat_id: seat_id, row: row_idx, col: col_idx } if neighbors_full
      end
    end
  end

  raise "hell" if potential_seats.length != 1
  potential_seats.first
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:strip)
  config = input.map do |raw|
    seat = SeatFinder.new(raw)
    seat.find
    { row: seat.row, column: seat.column, seat_id: seat_id(seat.row, seat.column) }
  end
  max_seat_id = config.max_by { |el| el[:seat_id] }[:seat_id]

  my_seat = find_my_seat(config)

  puts "Maximum seat_id: #{max_seat_id}"
  puts "Your seat is in row: #{my_seat[:row]} and column: #{my_seat[:col]} with seat_id: #{my_seat[:seat_id]}"
end
