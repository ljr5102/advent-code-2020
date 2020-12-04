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

  describe "#simple_valid?" do
    subject { passport.simple_valid? }

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

  describe "#complex_valid" do
    subject { passport.complex_valid? }

    before do
      allow_any_instance_of(Rules::Byr).to receive(:valid?).and_return(true)
      allow_any_instance_of(Rules::Iyr).to receive(:valid?).and_return(true)
      allow_any_instance_of(Rules::Eyr).to receive(:valid?).and_return(true)
      allow_any_instance_of(Rules::Hgt).to receive(:valid?).and_return(true)
      allow_any_instance_of(Rules::Hcl).to receive(:valid?).and_return(true)
      allow_any_instance_of(Rules::Ecl).to receive(:valid?).and_return(true)
      allow_any_instance_of(Rules::Pid).to receive(:valid?).and_return(true)
    end

    context "all rules return true" do
      it { is_expected.to be true }
    end

    context "any rule returns false" do
      before do
        allow_any_instance_of(Rules::Pid).to receive(:valid?).and_return(false)
      end

      it { is_expected.to be false }
    end
  end
end

describe Rules::Byr do
  let(:byr) { described_class.new(value) }

  describe "#valid?" do
    subject { byr.valid? }

    context "no value" do
      let(:value) { nil }

      it { is_expected.to be false }
    end

    context "non empty value" do
      context "within the acceptable range" do
        let(:value) { "1950" }

        it { is_expected.to be true }
      end

      context "minimum acceptable value" do
        let(:value) { "1920" }

        it { is_expected.to be true }
      end

      context "maximum acceptable value" do
        let(:value) { "2002" }

        it { is_expected.to be true }
      end

      context "below acceptable value" do
        let(:value) { "1919" }

        it { is_expected.to be false }
      end

      context "above acceptable value" do
        let(:value) { "2003" }

        it { is_expected.to be false }
      end
    end
  end
end

describe Rules::Iyr do
  let(:iyr) { described_class.new(value) }

  describe "#valid?" do
    subject { iyr.valid? }

    context "no value" do
      let(:value) { nil }

      it { is_expected.to be false }
    end

    context "non empty value" do
      context "within the acceptable range" do
        let(:value) { "2015" }

        it { is_expected.to be true }
      end

      context "minimum acceptable value" do
        let(:value) { "2010" }

        it { is_expected.to be true }
      end

      context "maximum acceptable value" do
        let(:value) { "2020" }

        it { is_expected.to be true }
      end

      context "below acceptable value" do
        let(:value) { "2009" }

        it { is_expected.to be false }
      end

      context "above acceptable value" do
        let(:value) { "2021" }

        it { is_expected.to be false }
      end
    end
  end
end

describe Rules::Eyr do
  let(:eyr) { described_class.new(value) }

  describe "#valid?" do
    subject { eyr.valid? }

    context "no value" do
      let(:value) { nil }

      it { is_expected.to be false }
    end

    context "non empty value" do
      context "within the acceptable range" do
        let(:value) { "2025" }

        it { is_expected.to be true }
      end

      context "minimum acceptable value" do
        let(:value) { "2020" }

        it { is_expected.to be true }
      end

      context "maximum acceptable value" do
        let(:value) { "2030" }

        it { is_expected.to be true }
      end

      context "below acceptable value" do
        let(:value) { "2019" }

        it { is_expected.to be false }
      end

      context "above acceptable value" do
        let(:value) { "2031" }

        it { is_expected.to be false }
      end
    end
  end
end

describe Rules::Hgt do
  let(:hgt) { described_class.new(value) }

  describe "#valid?" do
    subject { hgt.valid? }

    context "empty value" do
      let(:value) { nil }

      it { is_expected.to be false }
    end

    context "non empty value" do
      context "only letters" do
        let(:value) { "asdf" }

        it { is_expected.to be false }
      end

      context "mix of letters and numbers without meaning" do
        let(:value) { "asdf123asdf123" }

        it { is_expected.to be false }
      end

      context "includes valid input within invalid input" do
        let(:value) { "asdf123a150cm234sdf123" }

        it { is_expected.to be false }
      end

      context "includes valid input at ends of input" do
        let(:value) { "150asdf123a234sdf123cm" }

        it { is_expected.to be false }
      end

      context "include sensible input" do
        context "in cm" do
          context "minimum valid height" do
            let(:value) { "150cm" }

            it { is_expected.to be true }
          end

          context "maximum valid height" do
            let(:value) { "193cm" }

            it { is_expected.to be true }
          end

          context "below valid height" do
            let(:value) { "149cm" }

            it { is_expected.to be false }
          end

          context "above valid height" do
            let(:value) { "194cm" }

            it { is_expected.to be false }
          end

          context "in between" do
            let(:value) { "157cm" }

            it { is_expected.to be true }
          end
        end

        context "in in" do
          context "minimum valid height" do
            let(:value) { "59in" }

            it { is_expected.to be true }
          end

          context "maximum valid height" do
            let(:value) { "76in" }

            it { is_expected.to be true }
          end

          context "below valid height" do
            let(:value) { "58in" }

            it { is_expected.to be false }
          end

          context "above valid height" do
            let(:value) { "77in" }

            it { is_expected.to be false }
          end

          context "in between" do
            let(:value) { "69in" }

            it { is_expected.to be true }
          end
        end

        context "in ft" do
          let(:value) { "5ft" }

          it { is_expected.to be false }
        end

        context "in km" do
          let(:value) { "4km" }

          it { is_expected.to be false }
        end
      end
    end
  end
end

describe Rules::Hcl do
  let(:hcl) { described_class.new(value) }

  describe "#valid?" do
    subject { hcl.valid? }

    context "empty value" do
      let(:value) { nil }

      it { is_expected.to be false }
    end

    context "nonempty value" do
      context "nonsense input" do
        context "random chars" do
          let(:value) { "asdfsa" }

          it { is_expected.to be false }
        end

        context "random chars that include valid ones" do
          let(:value) { "ssf##112349afz" }

          it { is_expected.to be false }
        end

        context "random chars with valid input in the middle" do
          let(:value) { "ssf#012abc$$$$$" }

          it { is_expected.to be false }
        end

        context "random chars with valid input at the ends" do
          let(:value) { "#ssf$$$$$012abc" }

          it { is_expected.to be false }
        end
      end
    end

    context "sensible input" do
      context "missing #" do
        let(:value) { "012abc" }

        it { is_expected.to be false }
      end

      context "substituted #" do
        let(:value) { "$012abc" }

        it { is_expected.to be false }
      end

      context "too many chars after #" do
        let(:value) { "#012abcd" }

        it { is_expected.to be false }
      end

      context "too few chars after #" do
        let(:value) { "#02ab" }

        it { is_expected.to be false }
      end

      context "chars after # are not within proper ranges" do
        let(:value) { "#012abz" }

        it { is_expected.to be false }
      end

      context "chars after # are within proper ranges" do
        let(:value) { "#012abc" }

        it { is_expected.to be true }
      end
    end
  end
end

describe Rules::Ecl do
  let(:ecl) { described_class.new(value) }

  describe "#valid?" do
    subject { ecl.valid? }

    context "empty value" do
      let(:value) { nil }

      it { is_expected.to be false }
    end

    context "nonempty value" do
      context "not one of the acceptable values" do
        let(:value) { "gre" }

        it { is_expected.to be false }
      end

      context "one of the acceptable values" do
        let(:value) { "grn" }

        it { is_expected.to be true }
      end
    end
  end
end

describe Rules::Pid do
  let(:pid) { described_class.new(value) }

  describe "#valid?" do
    subject { pid.valid? }

    context "empty value" do
      let(:value) { nil }

      it { is_expected.to be false }
    end

    context "nonempty value" do
      context "alphanumeric" do
        context "only 9 chars" do
          let(:value) { "asdfg1234"}

          it { is_expected.to be false }
        end

        context "over 9 chars" do
          context "valid input in the middle" do
            let(:value) { "asdf000111222gdsa" }

            it { is_expected.to be false }
          end

          context "valid input at the ends" do
            let(:value){ "00012asdfdsadfasdfa1234" }

            it { is_expected.to be false }
          end
        end
      end

      context "numeric" do
        context "too many chars" do
          let(:value) { "0123456789"}

          it { is_expected.to be false }
        end

        context "not enough chars" do
          let(:value) { "01234567" }

          it { is_expected.to be false }
        end

        context "right amount" do
          let(:value) { "012345678" }

          it { is_expected.to be true }
        end
      end
    end
  end
end

describe "#count_simple_valid_passports" do
  subject { count_simple_valid_passports(input) }

  let(:input) do
    [
      instance_double(Passport, simple_valid?: true),
      instance_double(Passport, simple_valid?: false)
    ]
  end

  it { is_expected.to eq(1) }

  context "empty input" do
    let(:input) { [] }

    it { is_expected.to be_zero }
  end
end

describe "#count_complex_valid_passports" do
  subject { count_complex_valid_passports(input) }

  let(:input) do
    [
      instance_double(Passport, complex_valid?: true),
      instance_double(Passport, complex_valid?: false)
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
