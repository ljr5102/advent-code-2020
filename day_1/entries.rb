require "set"

def two_entries_2020(list)
  return if list.length <= 1

  seen_values = Set.new
  list.each do |value|
    needed_value = 2020 - value
    return value * needed_value if seen_values.include?(needed_value)
    seen_values << value
  end
  nil
end

def three_entries_2020(list)
  return if list.length <= 2

  seen_values = Set.new

  list.each_with_index do |value, idx|
    list.drop(idx + 1).each do |value_2|
      needed_value = 2020 - value_2 - value
      return value * value_2 * needed_value if seen_values.include?(needed_value)
      seen_values << value_2
    end
    seen_values << value
  end
  nil
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:to_i)
  two_entries_value = two_entries_2020(input)
  three_entries_value = three_entries_2020(input)
  puts "Two Entries Result: #{two_entries_value}"
  puts "Three Entries Result: #{three_entries_value}"
end
