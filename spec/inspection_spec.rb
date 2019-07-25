RSpec.describe H3 do
  include_context "constants"

  describe ".h3_resolution" do
    let(:h3_index) { valid_h3_index }
    let(:result) { 8 }

    subject(:h3_resolution) { H3.h3_resolution(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_base_cell" do
    let(:h3_index) { valid_h3_index }
    let(:result) { 12 }

    subject(:h3_base_cell) { H3.h3_base_cell(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".string_to_h3" do
    let(:h3_index) { "8928308280fffff"}
    let(:result) { h3_index.to_i(16) }

    subject(:string_to_h3) { H3.string_to_h3(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_to_string" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { h3_index.to_s(16) }

    subject(:h3_to_string) { H3.h3_to_string(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_valid?" do
    let(:h3_index) { valid_h3_index }
    let(:result) { true }

    subject(:h3_valid?) { H3.h3_valid?(h3_index) }

    it { is_expected.to eq(result) }

    context "when given an invalid h3_index" do
      let(:h3_index) { 1 }

      let(:result) { false }

      it "returns the expected result" do
        expect(h3_valid?).to eq(result)
      end
    end
  end

  describe ".h3_res_class_3?" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { true }

    subject(:h3_res_class_3) { H3.h3_res_class_3?(h3_index) }

    it { is_expected.to eq(result) }

    context "when the h3 index is not class III" do
      let(:h3_index) { "8828308280fffff".to_i(16) }
      let(:result) { false }

      it { is_expected.to eq(result) }
    end
  end

  describe ".h3_pentagon?" do
    let(:h3_index) { "821c07fffffffff".to_i(16) }
    let(:result) { true }

    subject(:h3_pentagon?) { H3.h3_pentagon?(h3_index) }

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

  describe ".h3_faces" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { [7] }

    subject(:max_face_count) { H3.h3_faces(h3_index) }

    it { is_expected.to eq(result) }

    context "when the h3 index is a pentagon" do
      let(:h3_index) { "821c07fffffffff".to_i(16) }
      let(:result) { [1, 2, 6, 7, 11] }

      it { is_expected.to eq(result) } 
    end
  end
end
