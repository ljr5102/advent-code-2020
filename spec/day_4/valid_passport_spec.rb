require "./day_4/valid_passport"

describe Passport do
  let(:options) do
    {
      byr: "1937",
      iyr: "2011",
      eyr: "2029",
      hgt: hgt,
      hcl: "#c0946f",
      ecl: "brn",
      pid: "67504914",
      cid: cid,
    }
  end
  let(:hgt) { "158cm" }
  let(:cid) { "155" }
  let(:passport) { described_class.new(options) }

  describe "#valid?" do
    subject { passport.valid? }

    context "has all possible passport fields" do
      it { is_expected.to be true }
    end

    context "missing fields" do
      context "missing a required field" do
        let(:hgt) { nil }

        it { is_expected.to be false }
      end

      context "missing the cid field" do
        let(:cid) { nil }

        it { is_expected.to be true }
      end

      context "missing both a required and non required field" do
        let(:hgt) { nil }
        let(:cid) { nil }

        it { is_expected.to be false }
      end
    end
  end
end

describe "#count_valid_passports" do
  subject { count_valid_passports(input) }

  let(:input) do
    [
      instance_double(Passport, valid?: true),
      instance_double(Passport, valid?: false)
    ]
  end

  it { is_expected.to eq(1) }

  context "empty input" do
    let(:input) { [] }

    it { is_expected.to be_zero }
  end
end

describe "#format_raw_input" do
  subject { format_raw_input(input) }

  context "standard input" do
    let(:input) do
      "a:1 b:2 c:3\nd:4 e:5 f:6\ng:7\n\na:8 b:9"
    end

    let(:expected) do
      [
        { a: "1", b: "2", c: "3", d: "4", e: "5", f: "6", g: "7" },
        { a: "8", b: "9" }
      ]
    end

    it { is_expected.to eq(expected) }
  end
end
