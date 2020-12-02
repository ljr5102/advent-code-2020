require "./day_2/valid_passwords"

describe PasswordPolicy do
  let(:policy) { described_class.new(char: char, int_one: int_one, int_two: int_two) }
  let(:char) { "a" }
  let(:int_one) { 2 }
  let(:int_two) { 4 }

  describe "#valid_by_length?" do
    subject { policy.valid_by_length?(password) }

    context "boundaries" do
      context "value does not meet minimum boundary" do
        let(:password) { "ab" }

        it { is_expected.to be false }
      end

      context "value meets minimum boundary exactly" do
        let(:password) { "aab" }

        it { is_expected.to be true }
      end

      context "value is between min and max boundary" do
        let(:password) { "aaab" }

        it { is_expected.to be true }
      end

      context "value meets maximum boundary exactly" do
        let(:password) { "aaaab" }

        it { is_expected.to be true }
      end

      context "value exceeds maximum boundary" do
        let(:password) { "aaaaab" }

        it { is_expected.to be false }
      end
    end
  end

  describe "#valid_by_position" do
    subject { policy.valid_by_position?(password) }

    context "password does not contain character anywhere" do
      let(:password) { "bbbbbbb" }

      it { is_expected.to be false }
    end

    context "password is shorter than positions in policy" do
      let(:password) { "b" }

      it { is_expected.to be false }
    end

    context "password contains charachter" do
      context "character is not in either position" do
        let(:password) { "abab" }

        it { is_expected.to be false }
      end

      context "character is in position 1" do
        let(:password) { "aaab" }

        it { is_expected.to be true }
      end

      context "character is in position 2" do
        let(:password) { "abaa" }

        it { is_expected.to be true }
      end

      context "character is in position 1 and 2" do
        let(:password) { "baba" }

        it { is_expected.to be false }
      end
    end
  end
end

describe "#valid_by_length_password_count" do
  subject { valid_by_length_password_count(input) }

  context "empty input" do
    let(:input) { [] }

    it { is_expected.to be_zero }
  end

  context "non empty input" do
    let(:input) do
      [
        instance_double(PasswordPolicy, valid_by_length?: password_1_validity),
        instance_double(PasswordPolicy, valid_by_length?: password_2_validity)
      ]
    end

    context "no passwords are valid" do
      let(:password_1_validity) { false }
      let(:password_2_validity) { false }

      it { is_expected.to be_zero }
    end

    context "1 password is valid" do
      let(:password_1_validity) { true }
      let(:password_2_validity) { false }

      it { is_expected.to eq(1) }
    end

    context "both passwords are valid" do
      let(:password_1_validity) { true }
      let(:password_2_validity) { true }

      it { is_expected.to eq(2) }
    end
  end
end

describe "#valid_by_position_password_count" do
  subject { valid_by_position_password_count(input) }

  context "empty input" do
    let(:input) { [] }

    it { is_expected.to be_zero }
  end

  context "non empty input" do
    let(:input) do
      [
        instance_double(PasswordPolicy, valid_by_position?: password_1_validity),
        instance_double(PasswordPolicy, valid_by_position?: password_2_validity)
      ]
    end

    context "no passwords are valid" do
      let(:password_1_validity) { false }
      let(:password_2_validity) { false }

      it { is_expected.to be_zero }
    end

    context "1 password is valid" do
      let(:password_1_validity) { true }
      let(:password_2_validity) { false }

      it { is_expected.to eq(1) }
    end

    context "both passwords are valid" do
      let(:password_1_validity) { true }
      let(:password_2_validity) { true }

      it { is_expected.to eq(2) }
    end
  end
end

describe "input_formatter" do
  subject { input_formatter(input) }

  context "empty input" do
    let(:input) { [] }

    it { is_expected.to eq([]) }
  end

  context "non empty input" do
    let(:input) do
      [
        "1-3 a: abcde",
        "2-9 c: ccccccccc",
        "10-98 d: ccdddccccccc",
      ]
    end

    it "transforms it to nested array of password policy with input" do
      subject.each do |policy, val|
        expect(policy).to be_an_instance_of(PasswordPolicy)
        expect(val).to be_an_instance_of(String)
      end
    end

    it "maintains the same length" do
      expect(subject.length).to eq(input.length)
    end
  end
end
