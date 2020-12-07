require "set"

def format_input(input)
  input.map do |str|
    split = str.split("contain")
    first_split = split.first.strip.gsub(" bags", "").gsub(" ", "_")

    last_split = split.last.strip
    comma_sep = last_split.split(",").map do |el|
      integer_value = 0
      el = el.strip.gsub(" bags", "").gsub(" bag", "").gsub(".", "")
      bag_split = el.split(" ")
      if bag_split.first == bag_split.first.to_i.to_s
        integer_value = bag_split.first.to_i
        bag_split = bag_split.drop(1)
      end
      color = bag_split.join("_")
      [integer_value, color]
    end

    node = BagNode.new(1, first_split)
    comma_sep.each do |child|
      next if child.first.zero?
      node.add_child(BagNode.new(child.first, child.last))
    end
    node
  end
end

class BagNode
  attr_reader :color, :quantity, :children

  def initialize(quantity, color)
    @quantity = quantity
    @color = color
    @children = []
  end

  def add_child(node)
    children << node
  end

  def has_child?(node_color)
    children.map(&:color).include?(node_color)
  end
end

def find_potential_outer_bags(primary_bag, node_rules)
  colors_to_check = [primary_bag.color]
  color_set = Set.new

  colors_to_check.each do |color|
    node_rules.select { |rule| rule.has_child?(color) }.each do |potential|
      color_set << potential
      if !colors_to_check.include?(potential.color)
        colors_to_check << potential.color
      end
    end
  end

  color_set
end

def find_total_bags_from(primary_bag, node_rules)
  primary_bags_to_check = [primary_bag.color]

  primary_bags_to_check.each do |bag|
    node_rules.select { |rule| rule.color == bag }.each do |rule|
      rule.children.each do |child|
        child.quantity.times do
          new_node = BagNode.new(1, child.color)
          primary_bags_to_check << new_node.color
        end
      end
    end
  end.drop(1)
end

if __FILE__ == $PROGRAM_NAME
  input = File.readlines("./input.txt").map(&:strip)
  formatted = format_input(input)
  potential_outers = find_potential_outer_bags(BagNode.new(1, "shiny_gold"), formatted)
  total_bags = find_total_bags_from(BagNode.new(1, "shiny_gold"), formatted)
  puts "The number of potential outer bag colors is: #{potential_outers.length}"
  puts "The number of bags within your bag is: #{total_bags.length}"
end
