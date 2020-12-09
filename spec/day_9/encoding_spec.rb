require "./day_9/encoding"

describe "#all_sums" do
  subject { all_sums(input) }

  context "empty input" do
    let(:input) { [] }

    it { is_expected.to eq({}) }
  end

  context "non empty input" do
    context "numbers are the same" do
      let(:input) { [1, 1, 1] }

      it { is_expected.to eq({ "1_1" => 2 }) }
    end

    context "numbers are different" do
      let(:input) { [1, 2, 3] }

      it { is_expected.to eq({ "1_2" => 3, "1_3" => 4, "2_3" => 5 }) }
    end
  end
end
