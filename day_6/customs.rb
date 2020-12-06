def number_distinct_answers(group)
  group.join("").split("").uniq.length
end

def number_same_answers(group)
  group.join("").split("").tally.count { |k, v| v == group.length }
end

if __FILE__ == $PROGRAM_NAME
  formatted = File.read("./input.txt").split("\n\n").map { |group| group.split("\n") }
  total_distinct = formatted.map do |group|
    number_distinct_answers(group)
  end.sum

  total_same = formatted.map do |group|
    number_same_answers(group)
  end.sum

  puts "Sum of distinct answers: #{total_distinct}"
  puts "Number of same answers: #{total_same}"
end
