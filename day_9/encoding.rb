def all_sums(input)
  output = {}
  input.each_with_index do |num_1, idx_1|
    input.each_with_index do |num_2, idx_2|
      next if idx_2 <= idx_1
      num_key = [num_1, num_2].sort.join("_")
      output[num_key] = num_1 + num_2
    end
  end
  output
end

def find_first_nonsum(input)
  preamble_range = (0..24)
  input.each_with_index do |num, idx|
    next if preamble_range.include?(idx)
    preamble = input[preamble_range]
    sums = all_sums(preamble)
    return num if !sums.values.include?(num)
    preamble_range = (preamble_range.first + 1)..(preamble_range.last + 1)
  end
end

def find_contiguous_range_sum(input, number)
  start_idx = 0
  end_idx = 0
  until start_idx == input.length
    sum = input[start_idx..end_idx].sum
    if sum < number
      end_idx += 1
    elsif sum > number
      start_idx += 1
    elsif sum == number
      return (start_idx..end_idx)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:to_i)
  value = find_first_nonsum(input)
  range = find_contiguous_range_sum(input, value)
  puts "The first number to not be a sum of the previous 25 is #{value}"
  puts "The sum of the first and last value from the valid range is #{input[range].min + input[range].max}"
end
