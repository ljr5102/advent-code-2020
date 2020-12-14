require "./day_14/ferry"

describe "#to_binary" do
  subject { to_binary(value) }

  TEST_CONFIG_1 = [
    { value: 11, expected: "1011" },
    { value: 73, expected: "1001001" },
    { value: 101, expected: "1100101" },
  ]

  TEST_CONFIG_1.each do |config|
    context "for value: #{config[:value]}" do
      let(:value) { config[:value] }
      it { is_expected.to eq(config[:expected]) }
    end
  end
end

describe "#to_decimal" do
  subject { to_decimal(value) }

  TEST_CONFIG_2 = [
    { value: "1011", expected: 11 },
    { value: "1001001", expected: 73 },
    { value: "1100101", expected: 101},
  ]

  TEST_CONFIG_2.each do |config|
    context "for value: #{config[:value]}" do
      let(:value) { config[:value] }
      it { is_expected.to eq(config[:expected]) }
    end
  end
end

describe "#to_36_bit" do
  subject { to_36_bit(value) }

  TEST_CONFIG_3 = [
    { value: "1011", expected: "000000000000000000000000000000001011" },
    { value: "1001001", expected: "000000000000000000000000000001001001" },
    { value: "1100101", expected: "000000000000000000000000000001100101"},
  ]

  TEST_CONFIG_3.each do |config|
    context "for value: #{config[:value]}" do
      let(:value) { config[:value] }
      it { is_expected.to eq(config[:expected]) }
    end
  end
end

describe "#apply_mask_to_val" do
  subject { apply_mask_to_val(mask, value) }

  let(:mask) { "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X" }

  TEST_CONFIG_4 = [
    { value: "000000000000000000000000000000001011", expected: "000000000000000000000000000001001001" },
    { value: "000000000000000000000000000001100101", expected: "000000000000000000000000000001100101" },
    { value: "000000000000000000000000000000000000", expected: "000000000000000000000000000001000000" },
  ]

  TEST_CONFIG_4.each do |config|
    context "for value: #{config[:value]}" do
      let(:value) { config[:value] }
      it { is_expected.to eq(config[:expected]) }
    end
  end
end

describe "#apply_mask_to_address" do
  subject { apply_mask_to_address(mask, value) }
  TEST_CONFIG_5 = [
    { mask: "000000000000000000000000000000X1001X", value: 42, expected: "000000000000000000000000000000X1101X" },
    { mask: "00000000000000000000000000000000X0XX", value: 26, expected: "00000000000000000000000000000001X0XX" },
  ]

  TEST_CONFIG_5.each do |config|
    context "for value: #{config[:value]}" do
      let(:mask) { config[:mask] }
      let(:value) { config[:value] }
      it { is_expected.to eq(config[:expected]) }
    end
  end
end

describe "masked_address_to_all_possible" do
  subject { masked_address_to_all_possible(value) }

  TEST_CONFIG_6 = [
    { value: "000000000000000000000000000000X1101X", expected: ["000000000000000000000000000000011010", "000000000000000000000000000000011011", "000000000000000000000000000000111010", "000000000000000000000000000000111011"] },
    { value: "00000000000000000000000000000001X0XX", expected: ["000000000000000000000000000000010000", "000000000000000000000000000000010001", "000000000000000000000000000000010010", "000000000000000000000000000000010011", "000000000000000000000000000000011000", "000000000000000000000000000000011001", "000000000000000000000000000000011010", "000000000000000000000000000000011011"] }
  ]

  TEST_CONFIG_6.each do |config|
    context "for value: #{config[:value]}" do
      let(:value) { config[:value] }
      it { is_expected.to match_array(config[:expected]) }
    end
  end
end
