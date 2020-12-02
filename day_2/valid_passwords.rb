class PasswordPolicy
  def initialize(char:, int_one:, int_two:)
    @char = char
    @int_one = int_one
    @int_two = int_two
  end

  def valid_by_length?(value)
    (int_one..int_two).include?(value.count(char))
  end

  def valid_by_position?(value)
    position_values = [value[int_one - 1], value[int_two - 1]]
    position_values.count(char) == 1
  end

  private

  attr_reader :char, :int_one, :int_two
end

def valid_by_length_password_count(input)
  input.count { |policy, value| policy.valid_by_length?(value) }
end

def valid_by_position_password_count(input)
  input.count { |policy, value| policy.valid_by_position?(value) }
end

def input_formatter(raw_input)
  raw_input.map do |raw_val|
    raw_range, raw_char, raw_password = raw_val.split(" ")
    int_one, int_two = raw_range.split("-").map(&:to_i)
    policy_char = raw_char[0]
    [PasswordPolicy.new(char: policy_char, int_one: int_one, int_two: int_two), raw_password]
  end
end

if __FILE__ == $PROGRAM_NAME
  raw_input = File.readlines("./input.txt")
  formatted = input_formatter(raw_input)
  puts "Number of valid passwords by length: #{valid_by_length_password_count(formatted)}"
  puts "Number of valid passwords by position: #{valid_by_position_password_count(formatted)}"
end
