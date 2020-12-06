require "./day_6/customs"

describe "#number_distinct_answers" do
  subject { number_distinct_answers(group) }

  context "empty input" do
    let(:group) { [] }

    it { is_expected.to be_zero }
  end

  context "non empty input" do
    context "all answer the same questions" do
      [
        { label: "single answer", input: ["a", "a", "a"], expected: 1 },
        { label: "multi answers", input: ["abc", "abc", "abc"], expected: 3 },
      ].each do |config|
        context config[:label] do
          let(:group) { config[:input] }

          it { is_expected.to eq(config[:expected]) }
        end
      end
    end

    context "all answer different questions" do
      [
        { label: "single answer", input: ["a", "b", "c"], expected: 3 },
        { label: "multi answers", input: ["abc", "def", "ghi"], expected: 9 },
      ].each do |config|
        context config[:label] do
          let(:group) { config[:input] }

          it { is_expected.to eq(config[:expected]) }
        end
      end
    end
  end
end

describe "#number_same_answers" do
  subject { number_same_answers(group) }

  context "empty input" do
    let(:group) { [] }

    it { is_expected.to be_zero }
  end

  context "non empty input" do
    context "all answer the same questions" do
      [
        { label: "single answer", input: ["a", "a", "a"], expected: 1 },
        { label: "multi answers", input: ["abc", "abc", "abc"], expected: 3 },
      ].each do |config|
        context config[:label] do
          let(:group) { config[:input] }

          it { is_expected.to eq(config[:expected]) }
        end
      end
    end

    context "all answer different questions" do
      [
        { label: "single answer", input: ["a", "b", "c"], expected: 0 },
        { label: "multi answers", input: ["abc", "def", "ghi"], expected: 0 },
      ].each do |config|
        context config[:label] do
          let(:group) { config[:input] }

          it { is_expected.to eq(config[:expected]) }
        end
      end
    end

    context "shared answers distributed across groups" do
      let(:group) { ["ab", "abd", "ac", "a", "afgh"] }

      it { is_expected.to eq(1) }
    end
  end
end
