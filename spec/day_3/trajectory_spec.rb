require "./day_3/trajectory"

describe Grid do
  let(:input) do
    [
      ["#", "."],
      ["#", "."],
      ["#", "."],
    ]
  end
  let(:grid) { described_class.populate_grid(input) }

  describe ".populate_grid" do
    subject { grid }

    it { is_expected.to be_an_instance_of(Grid) }
  end

  describe "[]" do
    subject { grid[x, y] }

    context "base cases" do
      context "starting point" do
        let(:x) { 0 }
        let(:y) { 0 }

        it { is_expected.to eq("#") }
      end

      context "last point" do
        let(:x) { 1 }
        let(:y) { 2 }

        it { is_expected.to eq(".") }
      end
    end

    context "outside initial input boundary" do
      context "negative x direction" do
        let(:x) { -1 }
        let(:y) { 5 }

        it "should raise an error" do
          expect { subject }.to raise_error("hell")
        end
      end

      context "negative y direction" do
        let(:x) { 1 }
        let(:y) { -5 }

        it "should raise an error" do
          expect { subject }.to raise_error("hell")
        end
      end

      context "positive x direction" do
        let(:x) { 2 }
        let(:y) { 0 }

        it { is_expected.to eq("#") }
      end

      context "positive y direction" do
        let(:x) { 2 }
        let(:y) { 4 }

        it "should raise an error" do
          expect { subject }.to raise_error("hell")
        end
      end
    end
  end

  describe "#invalid_spot?" do
    subject { grid.invalid_spot?(x, y) }

    context "within initial bounds" do
      let(:x) { 0 }
      let(:y) { 0 }

      it { is_expected.to be false }
    end

    context "outside initial bounds" do
      context "negative x value" do
        let(:x) { -1 }
        let(:y) { 0 }

        it { is_expected.to be true }
      end

      context "negative y value" do
        let(:x) { 0 }
        let(:y) { -1 }

        it { is_expected.to be true }
      end

      context "y past the map ending" do
        let(:x) { 0 }
        let(:y) { 3 }

        it { is_expected.to be true }
      end
    end
  end
end

describe Spot do
  let(:spot) { described_class.new(input) }

  describe "#obstacle?" do
    subject { spot.obstacle? }

    context "open spot" do
      let(:input) { "." }

      it { is_expected.to be false }
    end

    context "tree spot" do
      let(:input) { "#" }

      it { is_expected.to be true }
    end
  end
end
