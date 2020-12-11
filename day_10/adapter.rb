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
  input = input.sort
  maxs = [{ max: 0, streams: 1 }]
  current = nil
  loop do
    current = maxs.shift
    pot_conns = potential_connections(input, current[:max])
    break if pot_conns.empty?
    if maxs.empty?
      maxs = pot_conns.map { |conn| { max: conn, streams: current[:streams] } }
    else
      new_maxs = pot_conns.map do |conn|
        curr_max = maxs.find { |x| x[:max] == conn }
        if curr_max
          { max: curr_max[:max], streams: curr_max[:streams] + current[:streams] }
        else
          { max: conn, streams: current[:streams] }
        end
      end
      maxs = new_maxs
    end
  end
  current
end

def potential_connections(input, jolt_input)
  input.select { |jolt| (jolt - jolt_input).between?(1, 3) }
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:to_i)
  plot = diff_plot(input, 0)

  num_1_diffs = plot.find { |x| x[:diff] == 1 }[:count]
  num_3_diffs = plot.find { |x| x[:diff] == 3 }[:count]
  distinct = distinct_connections(input)

  puts "There are #{num_1_diffs} differences of 1 and #{num_3_diffs} differences of 3 for a product of #{num_1_diffs * num_3_diffs}"
  puts "There are #{distinct[:streams]} number of arrangements possible."
end
