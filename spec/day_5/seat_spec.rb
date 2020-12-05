require "./day_5/seat"

describe SeatFinder do
  let(:finder) { described_class.new(input) }

  TEST_CONFIG = [
    { input: "FBFBBFFRLR", row: 44, column: 5 },
    { input: "BFFFBBFRRR", row: 70, column: 7 },
    { input: "FFFBBBFRRR", row: 14, column: 7 },
    { input: "BBFFBBFRLL", row: 102, column: 4 },
  ]
  describe "#find" do
    subject { finder.find }

    context "invalid input" do
      context "not acceptable chars in input" do
        let(:input) { "asdf" }

        it "raises an error" do
          expect { subject }.to raise_error("hell")
        end
      end

      context "input doesn't yield a column result" do
        let(:input) { "FBFBBFFR" }

        it "raises an error" do
          expect { subject }.to raise_error("hell")
        end
      end

      context "input doesn't yield a row result" do
        let(:input) { "FBRLR" }

        it "raises an error" do
          expect { subject }.to raise_error("hell")
        end
      end
    end

    context "valid input" do
      TEST_CONFIG.each do |config|
        context "for input: #{config[:input]}" do
          let(:input) { config[:input] }

          it "finds the right row" do
            subject
            expect(finder.row).to eq(config[:row])
          end

          it "finds the right column" do
            subject
            expect(finder.column).to eq(config[:column])
          end
        end
      end
    end
  end
end

describe "#seat_id" do
  subject { seat_id(row, column) }

  SEAT_TEST_CONFIG = [
    { row: 0, column: 0, seat_id: 0 },
    { row: 5, column: 8, seat_id: 48 },
    { row: 0, column: 10, seat_id: 10 },
    { row: 123, column: 234, seat_id: 1218 },
  ]

  SEAT_TEST_CONFIG.each do |config|
    context "for row #{config[:row]} and column #{config[:column]}" do
      let(:row) { config[:row] }
      let(:column) { config[:column] }

      it { is_expected.to eq(config[:seat_id]) }
    end
  end
end
