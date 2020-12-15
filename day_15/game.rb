def final_num(final, input)
  result_map = {}
  current_num = nil
  spot = nil
  input.each_with_index do |el, idx|
    current_num = el
    spot = idx + 1
    result_map[current_num] = { val: current_num, most_recent: spot, previous: nil, times: 1 }
  end

  until spot == final
    mapped_num = result_map[current_num]
    spot += 1
    if mapped_num && mapped_num[:times] > 1
      current_num = mapped_num[:most_recent] - mapped_num[:previous]
    else
      current_num = 0
    end

    if result_map[current_num]
      result_map[current_num][:previous] = result_map[current_num][:most_recent]
      result_map[current_num][:most_recent] = spot
      result_map[current_num][:times] += 1
    else
      result_map[current_num] = { val: current_num, most_recent: spot, previous: nil, times: 1 }
    end
  end

  current_num
end

if __FILE__ == $PROGRAM_NAME
  input = [16, 11 ,15 ,0 ,1 ,7]
  final_2020 = final_num(2020, input)
  final_30_000_000 = final_num(30_000_000, input)

  puts "The 2020th number in the game is: #{final_2020}"
  puts "The 30_000_000th number in the game is #{final_30_000_000}"
end
