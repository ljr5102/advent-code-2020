require "./day_1/entries"

describe "#two_entries_2020" do
  subject { two_entries_2020(list) }

  context "list is empty" do
    let(:list) { [] }

    it { is_expected.to be_nil }
  end

  context "list is not empty" do
    context "list contains 1 item" do
      let(:list) { [123] }

      it { is_expected.to be_nil }
    end

    context "list contains multiple items" do
      context "no items add up to 2020" do
        let(:list) { [0, 0] }

        it { is_expected.to be_nil }
      end

      context "contains items that add up to 2020" do
        context "only 2 items in list" do
          let(:list) { [2020, 0] }

          it { is_expected.to be_zero }
        end

        context "many items in list" do
          let(:list) { [1721, 979, 366, 299, 675, 1456] }

          it { is_expected.to eq(514579) }
        end
      end
    end
  end
end

describe "#three_entries_2020" do
  subject { three_entries_2020(list) }

  context "list is empty" do
    let(:list) { [] }

    it { is_expected.to be_nil }
  end

  context "list is not empty" do
    context "list contains 1 item" do
      let(:list) { [123] }

      it { is_expected.to be_nil }
    end

    context "list contains 2 items" do
      let(:list) { [1009, 1011] }

      it { is_expected.to be_nil }
    end

    context "list contains over 2 items" do
      context "no items add up to 2020" do
        let(:list) { [0, 0, 1000] }

        it { is_expected.to be_nil }
      end

      context "contains items that add up to 2020" do
        context "only 3 items in list" do
          let(:list) { [2019, 0, 1] }

          it { is_expected.to be_zero }
        end

        context "many items in list" do
          let(:list) { [1721, 979, 366, 299, 675, 1456] }

          it { is_expected.to eq(241861950) }
        end
      end
    end
  end
end
