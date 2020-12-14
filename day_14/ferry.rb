def to_binary(num)
  result = ""
  until num.zero?
    rem = num % 2
    result = "#{rem}#{result}"
    num /= 2
  end
  result
end

def to_decimal(binary)
  result = 0
  binary.reverse.each_char.with_index do |char, idx|
    result += char.to_i * 2**idx
  end
  result
end

def to_36_bit(binary)
  "0" * (36 - binary.length) + binary
end

def apply_mask_to_val(mask, value)
  map = mask.split("").each_with_object({}).with_index { |(el, acc), idx| acc[idx] = el unless el == "X" }
  map.each do |k, v|
    value[k] = v
  end
  value
end

def apply_mask_to_address(mask ,value)
  result = ""
  binary = to_36_bit(to_binary(value))
  0.upto(mask.length - 1) do |idx|
    mask_el = mask[idx]
    binary_el = binary[idx]

    if mask_el == "0"
      result << binary_el
    elsif mask_el == "1"
      result << "1"
    elsif mask_el == "X"
      result << "X"
    else
      raise "hell"
    end
  end
  result
end

def masked_address_to_all_possible(value)
  float_map = {}
  value.each_char.with_index { |char, idx| float_map[idx] = char if char == "X" }
  floating_indexes = float_map.keys
  ["0", "1"].repeated_permutation(floating_indexes.length).to_a.map do |perm|
    result = value.dup
    floating_indexes.each_with_index { |float_idx, idx| result[float_idx] = perm[idx] }
    result
  end
end

if __FILE__ == $PROGRAM_NAME
  current_mask = nil
  current_result = {}
  input = File.readlines("./input.txt").map(&:strip).each do |el|
    instruction, value = el.split(" = ")
    if instruction == "mask"
      current_mask = value
    else
      address = instruction.gsub("mem[", "").gsub("]","").to_i
      dec = value.to_i
      binary = to_36_bit(to_binary(dec))
      masked = apply_mask_to_val(current_mask, binary)
      current_result[address] = masked
    end
  end

  sum = current_result.values.map { |el| to_decimal(el) }.sum

  puts "The sum of the results left in memory is: #{sum}"

  current_mask = nil
  current_result = {}
  input = File.readlines("./input.txt").map(&:strip).each do |el|
    instruction, value = el.split(" = ")
    if instruction == "mask"
      current_mask = value
    else
      address = instruction.gsub("mem[", "").gsub("]","").to_i
      masked = apply_mask_to_address(current_mask, address)
      all_addrs = masked_address_to_all_possible(masked)
      dec_addrs = all_addrs.map { |addr| to_decimal(addr) }
      dec_addrs.each do |dec_addr|
        current_result[dec_addr] = value.to_i
      end
    end
  end

  sum = current_result.values.sum

  puts "The sum of the results left in memory after version 2 is: #{sum}"
end
