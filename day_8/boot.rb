class Instruction
  attr_reader :accumulator, :index, :completed, :instructor, :value

  def initialize(instructor, value)
    @instructor = instructor
    @value = value
    @completed = false
  end

  def execute(acc, idx)
    adjust_acc(acc)
    adjust_idx(idx)
    mark_completed
  end

  private

  def adjust_acc(acc)
    @accumulator = acc + acc_adjustor_value
  end

  def adjust_idx(idx)
    @index = idx + idx_adjustor_value
  end

  def mark_completed
    @completed = true
  end

  def acc_adjustor_value
    {
      "nop" => 0,
      "acc" => value,
      "jmp" => 0
    }[instructor]
  end

  def idx_adjustor_value
    {
      "nop" => 1,
      "acc" => 1,
      "jmp" => value
    }[instructor]
  end
end

def execute_instructions(instructions)
  idx = 0
  acc = 0

  while idx < instructions.length
    instruction = instructions[idx]

    return { index: idx, accumulator: acc, terminated: true } if instruction.completed

    instruction.execute(acc, idx)
    acc = instruction.accumulator
    idx = instruction.index
  end

  { index: idx, accumulator: acc, terminated: false }
end

def fix_program(instructions)
  initial = execute_instructions(instructions)
  return initial if initial[:terminated] == false

  index_change = instructions.index { |instruction| ["nop", "jmp"].include?(instruction.instructor) }
  until index_change.nil?
    updated_instructions = instructions.map.with_index do |instruction, idx|
      if idx == index_change
        new_instructor = { "nop" => "jmp", "jmp" => "nop" }[instruction.instructor]
        Instruction.new(new_instructor, instruction.value)
      else
        Instruction.new(instruction.instructor, instruction.value)
      end
    end

    output = execute_instructions(updated_instructions)
    return output if output[:terminated] == false

    index_change = instructions.index.with_index { |instruction, idx| ["nop", "jmp"].include?(instruction.instructor) && idx > index_change }
  end
end

if __FILE__ == $PROGRAM_NAME
  raw = File.readlines("./input.txt").map(&:strip)
  formatted = raw.map { |instruction| instruction.split(" ") }
  instructions = formatted.map { |instructor, val| Instruction.new(instructor, val.to_i) }

  output = execute_instructions(instructions)

  instructions = formatted.map { |instructor, val| Instruction.new(instructor, val.to_i) }
  fixed = fix_program(instructions)

  puts "The value of the accumulator when executed is: #{output[:accumulator]}"
  puts "After the program is fixed, the value of the accumulator when executed is: #{fixed[:accumulator]}"
end
