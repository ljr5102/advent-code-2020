require "./day_8/boot"

describe Instruction do
  let(:instruction) { described_class.new(instructor, value) }
  describe "#call" do
    subject { instruction.execute(accumulator, index) }

    context "nop call" do
      let(:instructor) { "nop" }
      let(:value) { 10 }
      let(:accumulator) { 5 }
      let(:index) { 7 }

      it "does not do anything to the accumulator" do
        subject

        expect(instruction.accumulator).to eq(accumulator)
      end

      it "ups the index" do
        subject

        expect(instruction.index).to eq(index + 1)
      end

      it "marks the instruction completed" do
        expect(instruction.completed).to be false

        subject

        expect(instruction.completed).to be true
      end
    end

    context "acc call" do
      let(:instructor) { "acc" }
      let(:value) { 10 }
      let(:accumulator) { 5 }
      let(:index) { 7 }

      it "changes the accumulator based on the value" do
        subject

        expect(instruction.accumulator).to eq(accumulator + value)
      end

      it "ups the index" do
        subject

        expect(instruction.index).to eq(index + 1)
      end

      it "marks the instruction completed" do
        expect(instruction.completed).to be false

        subject

        expect(instruction.completed).to be true
      end
    end

    context "jmp call" do
      let(:instructor) { "jmp" }
      let(:value) { 10 }
      let(:accumulator) { 5 }
      let(:index) { 7 }

      it "does not change the accumulator" do
        subject

        expect(instruction.accumulator).to eq(accumulator)
      end

      it "ups the index by the value passed in" do
        subject

        expect(instruction.index).to eq(index + value)
      end

      it "marks the instruction completed" do
        expect(instruction.completed).to be false

        subject

        expect(instruction.completed).to be true
      end
    end
  end
end

describe "#execute_instructions" do
  subject { execute_instructions(instructions) }

  context "empty instructions" do
    let(:instructions) { [] }

    it "outputs a hash with index 0 and accumulator 0" do
      expect(subject[:accumulator]).to be_zero
      expect(subject[:index]).to be_zero
      expect(subject[:terminated]).to be false
    end
  end

  context "non empty instructions" do
    let(:instructions) do
      [
        instance_double(Instruction, execute: true, completed: completed, accumulator: acc, index: idx)
      ]
    end
    let(:acc) { 10 }
    let(:idx) { 7 }
    let(:completed) { false }

    it "returns a hash with index of what instructions return" do
      expect(subject[:index]).to eq(idx)
    end

    it "returns a hash with accumulator of what instructions return" do
      expect(subject[:accumulator]).to eq(acc)
    end

    it "returns a hash with terminated of false" do
      expect(subject[:terminated]).to eq(false)
    end

    context "instruction is completed" do
      let(:completed) { true }

      it "returns a hash with terminated of true" do
        expect(subject[:terminated]).to be true
      end

      it "returns the value of the index before instruction is executed" do
        expect(subject[:index]).to eq(0)
      end

      it "returns the value of the index before instruction is executed" do
        expect(subject[:accumulator]).to eq(0)
      end
    end
  end
end
