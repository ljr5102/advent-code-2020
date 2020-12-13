require "./day_13/bus"

describe Bus do
  let(:bus) { described_class.new(id) }

  describe "#id" do
    subject { bus.id }
    let(:id) { 23 }

    it { is_expected.to eq(id) }
  end

  describe "#departs_at?" do
    subject { bus.departs_at?(time) }

    let(:id) { 17 }

    context "time matches id" do
      let(:time) { 17 }

      it { is_expected.to eq(true) }
    end

    context "time is divisible by id" do
      let(:time) { 136 }

      it { is_expected.to eq(true) }
    end

    context "time is not divisible by id" do
      let(:time) { 140 }

      it { is_expected.to eq(false) }
    end
  end
end
