require "./day_10/adapter"

describe "#valid_connection" do
  subject { valid_connection(input, jolt_input) }

  let(:input) { [4, 1, 6, 9, 5] }

  TEST_CONFIGS = [
    { jolt_input: 0, expected_output: 1 },
    { jolt_input: 1, expected_output: 4 },
    { jolt_input: 4, expected_output: 5 },
    { jolt_input: 5, expected_output: 6 },
    { jolt_input: 6, expected_output: 9 },
    { jolt_input: 9, expected_output: 12 },
    { jolt_input: 11, expected_output: nil },
  ]

  TEST_CONFIGS.each do |config|
    context "for jolt input of #{config[:jolt_input]}" do
      let(:jolt_input) { config[:jolt_input] }

      it { is_expected.to eq(config[:expected_output]) }
    end
  end
end

describe "#diff_plot" do
  subject { diff_plot(input, starting_jolt) }

  let(:input) { [4, 1, 6, 9, 5] }
  let(:starting_jolt) { 0 }
  let(:expected) do
    [
      { diff: 1, count: 3 },
      { diff: 3, count: 3 },
    ]
  end

  it { is_expected.to match_array(expected) }
end
