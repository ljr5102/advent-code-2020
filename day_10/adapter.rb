require "byebug"
def valid_connection(input, jolt_input)
  return nil if jolt_input > input.max
  from_input = potential_connections(input, jolt_input).min
  from_input ||= input.max + 3
  from_input
end

def diff_plot(input, jolt_input)
  diffs = []
  output = valid_connection(input, jolt_input)
  until output.nil?
    diff = output - jolt_input
    existing_diff_hash = diffs.find { |el| el[:diff] == diff }
    if existing_diff_hash
      existing_diff_hash[:count] += 1
    else
      diffs << { diff: diff, count: 1 }
    end

    jolt_input = output
    output = valid_connection(input, jolt_input)
  end
  diffs
end

def distinct_connections(input)
end

def potential_connections(input, jolt_input)
  input.select { |jolt| (jolt - jolt_input).between?(1, 3) }
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:to_i)
  plot = diff_plot(input, 0)

  num_1_diffs = plot.find { |x| x[:diff] == 1 }[:count]
  num_3_diffs = plot.find { |x| x[:diff] == 3 }[:count]

  puts "There are #{num_1_diffs} differences of 1 and #{num_3_diffs} differences of 3 for a product of #{num_1_diffs * num_3_diffs}"
end
