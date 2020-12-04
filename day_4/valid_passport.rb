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

  def valid?
    required_fields.none?(&:nil?)
  end

  private

  def required_fields
    [byr, iyr, eyr, hgt, hcl, ecl, pid]
  end

  attr_reader :byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid, :cid
end

def count_valid_passports(input)
  input.count(&:valid?)
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

  puts "Number of valid passports: #{count_valid_passports(converted)}"
end
