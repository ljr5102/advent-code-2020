require "./day_16/ticket"

describe TicketField do
  let(:ticket_field) { described_class.new(name, ranges)}
  let(:name) { "my_field" }
  let(:ranges) { [(3..8), (15..17)] }

  describe "#valid?" do
    subject { ticket_field.valid?(input) }

    context "input within first range" do
      let(:input) { 5 }

      it { is_expected.to be true }
    end

    context "input at ends of first range" do
      context "beginning" do
        let(:input) { 3 }

        it { is_expected.to be true }
      end

      context "end" do
        let(:input) { 8 }

        it { is_expected.to be true }
      end
    end

    context "input within second range" do
      let(:input) { 16 }

      it { is_expected.to be true }
    end

    context "input at ends of first range" do
      context "beginning" do
        let(:input) { 15 }

        it { is_expected.to be true }
      end

      context "end" do
        let(:input) { 17 }

        it { is_expected.to be true }
      end
    end

    context "input in between both sets of ranges" do
      let(:input) { 12 }

      it { is_expected.to be false }
    end

    context "input before both sets of ranges" do
      let(:input) { 2 }

      it { is_expected.to be false }
    end

    context "input after both sets of ranges" do
      let(:input) { 25 }

      it { is_expected.to be false }
    end
  end
end

describe TicketFieldParser do
  let(:parser) { described_class.new(input) }
  let(:input) { ["departure location: 26-724 or 743-964", "departure station: 33-845 or 864-954"] }

  describe "#parse" do
    subject { parser.parse }

    let(:ticket_field_one) { instance_double(TicketField) }
    let(:ticket_field_two) { instance_double(TicketField) }

    before do
      expect(TicketField).to receive(:new).with(:departure_location, [(26..724), (743..964)]).and_return(ticket_field_one)
      expect(TicketField).to receive(:new).with(:departure_station, [(33..845), (864..954)]).and_return(ticket_field_two)
    end

    it { is_expected.to contain_exactly(ticket_field_one, ticket_field_two) }
  end
end

describe TicketScanner do
  let(:scanner) { described_class.new(fields) }
  let(:fields) { [field_one] }
  let(:field_one) { instance_double(TicketField) }

  describe "#error_rate" do
    subject { scanner.error_rate(tickets) }
    let(:tickets) { [[1, 1, 1], [1, 2, 1], [1, 3, 1]] }

    before do
      allow(field_one).to receive(:valid?).with(1).and_return(true)
      allow(field_one).to receive(:valid?).with(2).and_return(false)
      allow(field_one).to receive(:valid?).with(3).and_return(false)
    end

    it { is_expected.to eq(5) }
  end
end

describe TicketParser do
  let(:parser) { described_class.new(tickets) }
  let(:tickets) { ["1,2,3", "5,5,5", "0"] }

  describe "#parse" do
    subject { parser.parse }

    it { is_expected.to contain_exactly([1, 2, 3], [5, 5, 5], [0]) }
  end
end

describe RawInputParser do
  let(:parser) { described_class.new(input) }
  let(:input) do
    [
      *field_inputs.map { |input| "#{input}\n" },
      "\n",
      "your ticket:\n",
      *your_ticket_inputs.map { |input| "#{input}\n" },
      "\n",
      "nearby tickets:\n",
      *nearby_ticket_inputs.map { |input| "#{input}\n" },
    ]
  end
  let(:field_inputs) do
    ["class: 1-3 or 5-7", "row: 6-11 or 33-44"]
  end
  let(:your_ticket_inputs) do
    ["7,1,14"]
  end
  let(:nearby_ticket_inputs) do
    ["7,3,47", "40,4,50"]
  end
  let(:field_parser) { instance_double(TicketFieldParser, parse: parsed_fields) }
  let(:your_ticket_parser) { instance_double(TicketParser, parse: parsed_your_ticket) }
  let(:nearby_ticket_parser) { instance_double(TicketParser, parse: parsed_nearby_ticket) }
  let(:parsed_fields) { ["your fields"] }
  let(:parsed_your_ticket) { ["your ticket"] }
  let(:parsed_nearby_ticket) { ["nearby ticket"] }

  describe "#parse" do
    subject { parser.parse }

    before do
      allow(TicketFieldParser).to receive(:new).with(field_inputs).and_return(field_parser)
      allow(TicketParser).to receive(:new).with(your_ticket_inputs).and_return(your_ticket_parser)
      allow(TicketParser).to receive(:new).with(nearby_ticket_inputs).and_return(nearby_ticket_parser)
    end

    it "parses and sets all values appropriately" do
      subject

      expect(parser.ticket_fields).to eq(parsed_fields)
      expect(parser.your_ticket).to eq(parsed_your_ticket)
      expect(parser.nearby_tickets).to eq(parsed_nearby_ticket)
    end
  end
end
