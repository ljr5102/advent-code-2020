class Passport
  def initialize(opts)
    @byr = opts[:byr]
    @iyr = opts[:iyr]
    @eyr = opts[:eyr]
    @hgt = opts[:hgt]
    @hcl = opts[:hcl]
    @ecl = opts[:ecl]
    @pid = opts[:pid]
    @cid = opts[:cid]
  end

  def simple_valid?
    required_fields.none?(&:nil?)
  end

  def complex_valid?
    required_rules.all?(&:valid?)
  end

  private

  def required_fields
    [byr, iyr, eyr, hgt, hcl, ecl, pid]
  end

  def required_rules
    [
      Rules::Byr.new(byr),
      Rules::Iyr.new(iyr),
      Rules::Eyr.new(eyr),
      Rules::Hgt.new(hgt),
      Rules::Hcl.new(hcl),
      Rules::Ecl.new(ecl),
      Rules::Pid.new(pid),
    ]
  end

  attr_reader :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid
end

module Rules
  class Base
    def initialize(value)
      @value = value
    end

    private

    attr_reader :value
  end

  module RangeBasedRule
    def valid?
      (self.class::MIN_RANGE..self.class::MAX_RANGE).include?(value.to_i)
    end
  end

  class Byr < Base
    include RangeBasedRule
    MIN_RANGE = 1920
    MAX_RANGE = 2002
  end

  class Iyr < Base
    include RangeBasedRule
    MIN_RANGE = 2010
    MAX_RANGE = 2020
  end

  class Eyr < Base
    include RangeBasedRule
    MIN_RANGE = 2020
    MAX_RANGE = 2030
  end

  class Hgt < Base
    UNIT_RANGES = {
      "in" => (59..76),
      "cm" => (150..193),
    }
    def valid?
      return false if value.nil?

      numeric = value.match(/^[0-9]*/).to_a.join("")
      unit = value.match(/[a-z]*$/).to_a.join("")

      return false unless "#{numeric}#{unit}" == value

      return false unless UNIT_RANGES.keys.include?(unit)

      UNIT_RANGES[unit].include?(numeric.to_i)
    end
  end

  class Hcl < Base
    VALID_CHARS = (0..9).to_a.map(&:to_s).concat(("a".."f").to_a)

    def valid?
      return false if value.nil?

      hashtag = value.match(/^[#]/).to_a.join("")
      chars = value[1..]

      return false unless "#{hashtag}#{chars}" == value
      return false unless chars.length == 6

      chars.split("").all? { |char| VALID_CHARS.include?(char) }
    end
  end

  class Ecl < Base
    ALLOWED = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].freeze

    def valid?
      ALLOWED.include?(value)
    end
  end

  class Pid < Base
    def valid?
      return false if value.nil?
      return false if value.length != 9

      value.match(/[0-9]*/).to_a.join("") == value
    end
  end
end

def count_simple_valid_passports(input)
  input.count(&:simple_valid?)
end

def count_complex_valid_passports(input)
  input.count(&:complex_valid?)
end

def format_raw_input(raw)
  raw.split("\n\n").map do |el|
    Hash[el.gsub("\n", " ").split(" ").map { |key| key.split(":") }].transform_keys(&:to_sym)
  end
end

if __FILE__ == $PROGRAM_NAME
  raw = File.read("./input.txt")
  formatted = format_raw_input(raw)
  converted = formatted.map { |opts| Passport.new(opts) }

  puts "Number of simple valid passports: #{count_simple_valid_passports(converted)}"
  puts "Number of complex valid passports: #{count_complex_valid_passports(converted)}"
end
