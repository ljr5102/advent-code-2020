require "./day_15/game"

describe "#final_num" do
  subject { final_num(final, input) }
  let(:final) { 2020 }

  TEST_1_CONFIG = [
    { input: [0, 3, 6], output: 436 },
    { input: [1, 3, 2], output: 1 },
    { input: [2, 1, 3], output: 10 },
    { input: [1, 2, 3], output: 27 },
    { input: [2, 3, 1], output: 78 },
    { input: [3, 2, 1], output: 438 },
    { input: [3, 1, 2], output: 1836 },
  ].each do |config|
    context "for input: #{config[:input]}" do
      let(:input) { config[:input] }

      it { is_expected.to eq(config[:output]) }
    end
  end
end
