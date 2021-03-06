def evaluate(expression)
  result = 0
  operator = "+"
  expression = expression.gsub(" ", "")
  idx = 0
  while idx < expression.length
    char = expression[idx]
    if char == "+" || char == "*"
      operator = char
      idx += 1
    elsif char == "("
      nesting = 1
      nested_expression = ""
      nested_idx = idx + 1
      nested_char = expression[nested_idx]
      until nesting == 0
        nesting += 1 if nested_char == "("
        nesting -= 1 if nested_char == ")"
        nested_expression << nested_char unless nesting == 0
        nested_idx += 1
        nested_char = expression[nested_idx]
      end
      result = operate(operator, result, evaluate(nested_expression))
      idx = nested_idx
    else
      result = operate(operator, result, char.to_i)
      idx += 1
    end
  end
  result
end

def evaluate_v2(expression)
  result = 0
  operator = "+"
  expression = expression.gsub(" ", "")
  idx = 0
  while idx < expression.length
    char = expression[idx]
    if char == "+"
      operator = char
      idx += 1
    elsif char == "*"
      remaining = expression[(idx + 1)..]
      result = operate("*", result, evaluate_v2(remaining))
      idx = expression.length
    elsif char == "("
      nesting = 1
      nested_expression = ""
      nested_idx = idx + 1
      nested_char = expression[nested_idx]
      until nesting == 0
        nesting += 1 if nested_char == "("
        nesting -= 1 if nested_char == ")"
        nested_expression << nested_char unless nesting == 0
        nested_idx += 1
        nested_char = expression[nested_idx]
      end
      result = operate(operator, result, evaluate_v2(nested_expression))
      idx = nested_idx
    else
      result = operate(operator, result, char.to_i)
      idx += 1
    end
  end
  result
end

def operate(char, num1, num2)
  if char == "+"
    num1 + num2
  elsif char == "*"
    num1 * num2
  else
    raise "hell"
  end
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:strip)

  sum = input.sum { |expression| evaluate(expression) }
  sum_v2 = input.sum { |expression| evaluate_v2(expression) }

  puts "The sum of each expression result is #{sum}"
  puts "The sum of each expression version 2 result is #{sum_v2}"
end
