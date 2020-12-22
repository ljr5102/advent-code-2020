require "byebug"
require "set"

def play_game(deck_one, deck_two)
  until deck_one.empty? || deck_two.empty?
    play_round(deck_one, deck_two)
  end
  deck_one.empty? ? deck_two : deck_one
end

def play_recursive_game(deck_one, deck_two)
  round_configs = Set.new
  until deck_one.empty? || deck_two.empty?
    config_hash = deck_one.join("") + deck_two.join("")
    return { deck: deck_one, early: true } if round_configs.include?(config_hash)
    round_configs << config_hash
    play_recursive_round(deck_one, deck_two)
  end
  deck_one.empty? ? { deck: deck_two, early: false } : { deck: deck_one, early: false }
end

def play_round(deck_one, deck_two)
  card_one = deck_one.shift
  card_two = deck_two.shift

  winning_card = card_one > card_two ? card_one : card_two
  losing_card = card_one > card_two ? card_two : card_one
  winning_deck = card_one > card_two ? deck_one : deck_two

  winning_deck.push(winning_card)
  winning_deck.push(losing_card)
end

def play_recursive_round(deck_one, deck_two)
  card_one = deck_one.shift
  card_two = deck_two.shift

  if deck_one.length >= card_one && deck_two.length >= card_two
    sub_deck_one = deck_one.take(card_one)
    sub_deck_two = deck_two.take(card_two)
    deck_hash = play_recursive_game(sub_deck_one, sub_deck_two)
    if deck_hash[:early]
      winning_card = card_one
      losing_card = card_two
      winning_deck = deck_one
    else
      winning_card = sub_deck_one.length > sub_deck_two.length ? card_one : card_two
      losing_card = sub_deck_one.length > sub_deck_two.length ? card_two : card_one
      winning_deck = sub_deck_one.length > sub_deck_two.length ? deck_one : deck_two
    end
  else
    winning_card = card_one > card_two ? card_one : card_two
    losing_card = card_one > card_two ? card_two : card_one
    winning_deck = card_one > card_two ? deck_one : deck_two
  end

  winning_deck.push(winning_card)
  winning_deck.push(losing_card)
end

def calculate_score(deck)
  acc = 0
  deck.reverse.each_with_index do |el, idx|
    acc += (idx + 1) * el
  end
  acc
end

if __FILE__ == $PROGRAM_NAME
  deck_one = []
  deck_two = []
  current = nil
  input = File.readlines("./input.txt").map(&:strip).each do |el|
    next if el.empty?
    if el == "Player 1:"
      current = deck_one
    elsif el == "Player 2:"
      current = deck_two
    else
      current << el.to_i
    end
  end

  # winner = play_game(deck_one, deck_two)
  # score = calculate_score(winner)

  winner = play_recursive_game(deck_one, deck_two)[:deck]
  score = calculate_score(winner) # 33748 is too high
  puts "Winning score is #{score}."
end
