require "./day_18/math"

describe "#evaluate" do
  subject { evaluate(expression) }

  TEST_CONFIG = [
    { expression: "1 + 2 * 3 + 4 * 5 + 6 ", result: 71 },
    { expression: "1 + (2 * 3) + (4 * (5 + 6))", result: 51 },
    { expression: "2 * 3 + (4 * 5)", result: 26 },
    { expression: "5 + (8 * 3 + 9 + 3 * 4 * 3)", result: 437 },
    { expression: "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", result: 12240 },
    { expression: "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", result: 13632 },
  ].each do |config|
    context "for expression #{config[:expression]}" do
      let(:expression) { config[:expression] }

      it {is_expected.to eq(config[:result]) }
    end
  end
end

describe "#evaluate_v2" do
  subject { evaluate_v2(expression) }

  TEST_CONFIG = [
    { expression: "1 + 2 * 3 + 4 * 5 + 6 ", result: 231 },
    { expression: "1 + (2 * 3) + (4 * (5 + 6))", result: 51 },
    { expression: "2 * 3 + (4 * 5)", result: 46 },
    { expression: "5 + (8 * 3 + 9 + 3 * 4 * 3)", result: 1445 },
    { expression: "5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", result: 669060 },
    { expression: "((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", result: 23340 },
  ].each do |config|
    context "for expression #{config[:expression]}" do
      let(:expression) { config[:expression] }

      it {is_expected.to eq(config[:result]) }
    end
  end
end
