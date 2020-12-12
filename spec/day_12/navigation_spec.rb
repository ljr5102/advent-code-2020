require "./day_12/navigation"

describe Ship do
  let(:ship) { described_class.new }

  describe "#navigate" do
    subject { ship.navigate(dir, val) }

    context "no change in direction" do
      context "movement in current direction" do
        let(:dir) { :E }
        let(:val) { 5 }

        it "updates the value of the ships value for the corresponding direction" do
          subject

          expect(ship.x_value).to eq(5)
        end

        it "does not update the value for direction not corresponding to value passed in" do
          subject

          expect(ship.y_value).to eq(0)
        end

        it "does not update the direction" do
          subject

          expect(ship.dir).to eq(:E)
        end
      end

      context "movement in horizontal direction different from current" do
        let(:dir) { :W }
        let(:val) { 5 }

        it "updates the value of the ships value for the corresponding direction" do
          subject

          expect(ship.x_value).to eq(-5)
        end

        it "does not update the value for direction not corresponding to value passed in" do
          subject

          expect(ship.y_value).to eq(0)
        end

        it "does not update the direction" do
          subject

          expect(ship.dir).to eq(:E)
        end
      end

      context "movement in vertical direction different from current" do
        let(:dir) { :N }
        let(:val) { 5 }

        it "updates the value of the ships value for the corresponding direction" do
          subject

          expect(ship.y_value).to eq(5)
        end

        it "does not update the value for direction not corresponding to value passed in" do
          subject

          expect(ship.x_value).to eq(0)
        end

        it "does not update the direction" do
          subject

          expect(ship.dir).to eq(:E)
        end
      end

      context "movement in the forward direction" do
        let(:dir) { :F }
        let(:val) { 5 }

        it "updates the value of the ships value for the corresponding direction" do
          subject

          expect(ship.x_value).to eq(5)
        end

        it "does not update the value for direction not corresponding to value passed in" do
          subject

          expect(ship.y_value).to eq(0)
        end

        it "does not update the direction" do
          subject

          expect(ship.dir).to eq(:E)
        end
      end
    end

    context "change in direction" do
      let(:dir) { :R }
      let(:val) { 90 }

      it "does not update the x_value" do
        subject

        expect(ship.x_value).to eq(0)
      end

      it "does not update the y_value" do
        subject

        expect(ship.y_value).to eq(0)
      end

      it "updates the direction appropriately" do
        subject

        expect(ship.dir).to eq(:S)
      end
    end
  end

  describe "#navigate_to_waypoint" do
    subject { ship.navigate_to_waypoint(val, waypoint) }

    let(:waypoint) { instance_double(Waypoint, x_value: x_value, y_value: y_value) }
    let(:val) { 7 }

    context "waypoint is positive x and postive y" do
      let(:x_value) { 5 }
      let(:y_value) { 8 }

      it "moves the ship to the proper spot" do
        subject

        expect(ship.x_value).to eq(35)
        expect(ship.y_value).to eq(56)
      end
    end

    context "waypoint is positive x and negative y" do
      let(:x_value) { 5 }
      let(:y_value) { -8 }

      it "moves the ship to the proper spot" do
        subject

        expect(ship.x_value).to eq(35)
        expect(ship.y_value).to eq(-56)
      end
    end

    context "waypoint is negative x and positive y" do
      let(:x_value) { -5 }
      let(:y_value) { 8 }

      it "moves the ship to the proper spot" do
        subject

        expect(ship.x_value).to eq(-35)
        expect(ship.y_value).to eq(56)
      end
    end

    context "waypoint is negative x and negative y" do
      let(:x_value) { -5 }
      let(:y_value) { -8 }

      it "moves the ship to the proper spot" do
        subject

        expect(ship.x_value).to eq(-35)
        expect(ship.y_value).to eq(-56)
      end
    end
  end

  describe "#manhattan_distance" do
    subject { ship.manhattan_distance }

    context "starting position" do
      it { is_expected.to be_zero }
    end

    context "different x and y values" do
      before do
        allow(ship).to receive(:x_value).and_return(x_value)
        allow(ship).to receive(:y_value).and_return(y_value)
      end

      context "both positive values" do
        let(:x_value) { 5 }
        let(:y_value) { 7 }

        it { is_expected.to eq(12) }
      end

      context "both negative values" do
        let(:x_value) { -5 }
        let(:y_value) { -7 }

        it { is_expected.to eq(12) }
      end

      context "mix of negative and positivevalues" do
        let(:x_value) { 5 }
        let(:y_value) { -7 }

        it { is_expected.to eq(12) }
      end
    end
  end
end

describe Waypoint do
  let(:waypoint) { described_class.new }

  describe "#initialization" do
    it "sets the correct initial values" do
      expect(waypoint.x_value).to eq(10)
      expect(waypoint.y_value).to eq(1)
    end
  end

  describe "#move" do
    subject { waypoint.move(direction, value) }

    context "in x direction" do
      let(:direction) { :E }
      let(:value) { 5 }

      it "moves the waypoint to the proper spot" do
        subject

        expect(waypoint.x_value).to eq(15)
        expect(waypoint.y_value).to eq(1)
      end
    end

    context "in y direction" do
      let(:direction) { :S }
      let(:value) { 5 }

      it "moves the waypoint to the proper spot" do
        subject

        expect(waypoint.x_value).to eq(10)
        expect(waypoint.y_value).to eq(-4)
      end
    end

    context "rotating" do
      CONFIGS = [
        { x_value: 10, y_value: 4, dir: :R, val: 90, expected_x: 4, expected_y: -10 },
        { x_value: -10, y_value: 4, dir: :R, val: 90, expected_x: 4, expected_y: 10 },
        { x_value: 10, y_value: -4, dir: :R, val: 90, expected_x: -4, expected_y: -10 },
        { x_value: -10, y_value: -4, dir: :R, val: 90, expected_x: -4, expected_y: 10 },
        { x_value: 10, y_value: 4, dir: :L, val: 90, expected_x: -4, expected_y: 10 },
        { x_value: -10, y_value: 4, dir: :L, val: 90, expected_x: -4, expected_y: -10 },
        { x_value: 10, y_value: -4, dir: :L, val: 90, expected_x: 4, expected_y: 10 },
        { x_value: -10, y_value: -4, dir: :L, val: 90, expected_x: 4, expected_y: -10 },
        { x_value: 10, y_value: 4, dir: :R, val: 180, expected_x: -10, expected_y: -4 },
        { x_value: -10, y_value: 4, dir: :R, val: 180, expected_x: 10, expected_y: -4 },
        { x_value: 10, y_value: -4, dir: :R, val: 180, expected_x: -10, expected_y: 4 },
        { x_value: -10, y_value: -4, dir: :R, val: 180, expected_x: 10, expected_y: 4 },
        { x_value: 10, y_value: 4, dir: :L, val: 180, expected_x: -10, expected_y: -4 },
        { x_value: -10, y_value: 4, dir: :L, val: 180, expected_x: 10, expected_y: -4 },
        { x_value: 10, y_value: -4, dir: :L, val: 180, expected_x: -10, expected_y: 4 },
        { x_value: -10, y_value: -4, dir: :L, val: 180, expected_x: 10, expected_y: 4 },
        { x_value: 10, y_value: 4, dir: :R, val: 270, expected_x: -4, expected_y: 10 },
        { x_value: -10, y_value: 4, dir: :R, val: 270, expected_x: -4, expected_y: -10 },
        { x_value: 10, y_value: -4, dir: :R, val: 270, expected_x: 4, expected_y: 10 },
        { x_value: -10, y_value: -4, dir: :R, val: 270, expected_x: 4, expected_y: -10 },
        { x_value: 10, y_value: 4, dir: :L, val: 270, expected_x: 4, expected_y: -10 },
        { x_value: -10, y_value: 4, dir: :L, val: 270, expected_x: 4, expected_y: 10 },
        { x_value: 10, y_value: -4, dir: :L, val: 270, expected_x: -4, expected_y: -10 },
        { x_value: -10, y_value: -4, dir: :L, val: 270, expected_x: -4, expected_y: 10 },
      ].each do |config|
        context "starting at x: #{config[:x_value]}, y: #{config[:y_value]} and moving #{config[:val]} in direction #{config[:dir]}" do
          let(:direction) { config[:dir] }
          let(:value) { config[:val] }

          before do
            waypoint.x_value = config[:x_value]
            waypoint.y_value = config[:y_value]
          end

          it "moves the waypoint to the proper spot" do
            subject

            expect(waypoint.x_value).to eq(config[:expected_x])
            expect(waypoint.y_value).to eq(config[:expected_y])
          end
        end
      end
    end
  end
end

describe Dispatcher do
  let(:dispatcher) { described_class.new(ship, waypoint, instructions) }
  let(:ship) { instance_double(Ship, navigate_to_waypoint: true) }
  let(:waypoint) { instance_double(Waypoint, move: true) }

  describe "#dispatch" do
    subject { dispatcher.dispatch }

    context "instructions that are for ship" do
      let(:instructions) do
        [
          { direction: :F, value: 7 }
        ]
      end

      it "only sends the instruction to the ship" do
        expect(ship).to receive(:navigate_to_waypoint).with(7, waypoint)

        subject
      end
    end

    context "instructions that are for waypoint" do
      let(:instructions) do
        [
          { direction: :N, value: 7 }
        ]
      end

      it "only sends the instruction to the ship" do
        expect(waypoint).to receive(:move).with(:N, 7)

        subject
      end
    end
  end
end
