RSpec.describe H3 do
  include_context "constants"

  describe ".resolution" do
    let(:h3_index) { valid_h3_index }
    let(:result) { 8 }

    subject(:resolution) { H3.resolution(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".base_cell" do
    let(:h3_index) { valid_h3_index }
    let(:result) { 12 }

    subject(:base_cell) { H3.base_cell(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".from_string" do
    subject(:from_string) { H3.from_string(h3_index) }
    context "- valid" do
      let(:h3_index) { "8928308280fffff"}
      let(:result) { h3_index.to_i(16) }

      it { is_expected.to eq(result) }
    end

    context "- nil" do
      let(:h3_index) { nil }

      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".to_string" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { h3_index.to_s(16) }

    subject(:to_string) { H3.to_string(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".valid?" do
    let(:h3_index) { valid_h3_index }
    let(:result) { true }

    subject(:valid?) { H3.valid?(h3_index) }

    it { is_expected.to eq(result) }

    context "when given an invalid h3_index" do
      let(:h3_index) { 1 }

      let(:result) { false }

      it "returns the expected result" do
        expect(valid?).to eq(result)
      end
    end
  end

  describe ".class_3_resolution?" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { true }

    subject(:class_3_resolution) { H3.class_3_resolution?(h3_index) }

    it { is_expected.to eq(result) }

    context "when the h3 index is not class III" do
      let(:h3_index) { "8828308280fffff".to_i(16) }
      let(:result) { false }

      it { is_expected.to eq(result) }
    end
  end

  describe ".pentagon?" do
    let(:h3_index) { "821c07fffffffff".to_i(16) }
    let(:result) { true }

    subject(:pentagon?) { H3.pentagon?(h3_index) }

    it { is_expected.to eq(result) }

    context "when the h3 index is not a pentagon" do
      let(:h3_index) { "8928308280fffff".to_i(16) }
      let(:result) { false }

      it { is_expected.to eq(result) } 
    end
  end

  describe ".max_face_count" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { 2 }

    subject(:max_face_count) { H3.max_face_count(h3_index) }

    it { is_expected.to eq(result) }

    context "when the h3 index is a pentagon" do
      let(:h3_index) { "821c07fffffffff".to_i(16) }
      let(:result) { 5 }

      it { is_expected.to eq(result) } 
    end
  end

  describe ".faces" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { [7] }

    subject(:faces) { H3.faces(h3_index) }

    it { is_expected.to eq(result) }

    context "when the h3 index is a pentagon" do
      let(:h3_index) { "821c07fffffffff".to_i(16) }
      let(:result) { [1, 2, 6, 7, 11] }

      it { is_expected.to eq(result) } 
    end
  end
end
