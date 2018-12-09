require "bigdecimal"

RSpec.describe H3Ruby do
  let(:valid_h3_index) { "8819429a9dfffff".to_i(16) }
  let(:too_long_number) { 10_000_000_000_000_000_000_000 }

  describe ".max_kring_size" do
    let(:k) { 2 }
    let(:result) { 19 }

    subject(:max_kring_size) { H3Ruby.max_kring_size(k) }

    it { is_expected.to eq(result) }

    context "when provided with a bad k value" do
      let(:k) { "boom" }

      it "raises an error" do
        expect { max_kring_size }.to raise_error(TypeError)
      end
    end

    context "when given a k too large" do
      let(:k) { too_long_number }

      it "raises an error" do
        expect { max_kring_size }.to raise_error(RangeError)
      end
    end  
  end

  describe ".geo_to_h3" do
    let(:resolution) { 8 }
    let(:coords) { [53.959130, -1.079230]}
    let(:result) { valid_h3_index }

    subject(:geo_to_h3) { H3Ruby.geo_to_h3(coords, resolution) }

    it { is_expected.to eq(result) }

    context "when given more than 2 values" do
      let(:coords) { [1, 2, 3] }

      it "raises an error" do
        expect { geo_to_h3 }.to raise_error(ArgumentError)
      end
    end

    context "when given a non array" do
      let(:coords) { "boom" }

      it "raises an error" do
        expect { geo_to_h3 }.to raise_error(TypeError)
      end
    end

    context "when given a resolution too large" do
      let(:resolution) { too_long_number }

      it "raises an error" do
        expect { geo_to_h3 }.to raise_error(RangeError)
      end
    end    
  end

  describe ".h3_to_geo" do
    let(:h3_index) { valid_h3_index }
    let(:result) { [53.95860421941974, -1.081195647095136] }

    subject(:h3_to_geo) { H3Ruby.h3_to_geo(h3_index) }

    it { is_expected.to eq(result) }

    context "when given an invalid h3_index" do
      let(:h3_index) { "boom" }

      it "raises an error" do
        expect { h3_to_geo }.to raise_error(TypeError)
      end
    end

    context "when given an index that's too large" do
      let(:h3_index) { too_long_number }

      it "raises an error" do
        expect { h3_to_geo }.to raise_error(RangeError)
      end
    end
  end

  describe ".h3_valid?" do
    let(:h3_index) { valid_h3_index }
    let(:result) { true }

    subject(:h3_valid?) { H3Ruby.h3_valid?(h3_index) }

    it { is_expected.to eq(result) }

    context "when given an invalid h3_index" do
      let(:h3_index) { 1 }

      let(:result) { false }

      it "returns the expected result" do
        expect(h3_valid?).to eq(result)
      end
    end
  end

  describe ".num_hexagons" do
    let(:resolution) { 2 }
    let(:result) { 5882 }

    subject(:num_hexagons) { H3Ruby.num_hexagons(resolution) }

    it { is_expected.to eq(result) }

    context "when given an invalid resolution" do
      let(:resolution) { too_long_number }
      let(:result) { false }

      it "returns the expected result" do
        expect { num_hexagons }.to raise_error(RangeError)
      end
    end
  end

  describe ".degs_to_rads" do
    let(:degs) { 100 }
    let(:result) { 1.7453292519943295 }

    subject(:degs_to_rads) { H3Ruby.degs_to_rads(degs) }

    it { is_expected.to eq(result) }
  end

  describe ".rads_to_degs" do
    let(:rads) { 1.7453292519943295 }
    let(:result) { 100 }

    subject(:rads_to_degs) { H3Ruby.rads_to_degs(rads) }

    it { is_expected.to eq(result) }
  end

  describe ".hex_area_km2" do
    let(:resolution) { 2 }
    let(:result) { 86745.85403 }

    subject(:hex_area_km2) { H3Ruby.hex_area_km2(resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".hex_area_m2" do
    let(:resolution) { 2 }
    let(:result) { 86745854035.0 }

    subject(:hex_area_m2) { H3Ruby.hex_area_m2(resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".edge_length_km" do
    let(:resolution) { 2 }
    let(:result) { 158.2446558 }

    subject(:edge_length_km) { H3Ruby.edge_length_km(resolution) }

    it { is_expected.to eq(result) }
  end
      
  describe ".edge_length_m" do
    let(:resolution) { 2 }
    let(:result) { 158244.6558 }

    subject(:edge_length_m) { H3Ruby.edge_length_m(resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_res_class_3?" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:result) { true }

    subject(:h3_res_class_3) { H3Ruby.h3_res_class_3?(h3_index) }

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

    subject(:h3_pentagon?) { H3Ruby.h3_pentagon?(h3_index) }

    it { is_expected.to eq(result) }

    context "when the h3 index is not a pentagon" do
      let(:h3_index) { "8928308280fffff".to_i(16) }
      let(:result) { false }

      it { is_expected.to eq(result) } 
    end
  end

  describe ".h3_unidirectional_edge_valid?" do
    let(:edge) { "11928308280fffff".to_i(16) }
    let(:result) { true }

    subject(:h3_unidirectional_edge_valid?) { H3Ruby.h3_unidirectional_edge_valid?(edge) }

    it { is_expected.to eq(result) }

    context "when the h3 index is not a valid unidirectional edge" do
      let(:edge) { "8928308280fffff".to_i(16) }
      let(:result) { false }

      it { is_expected.to eq(result) }
    end
  end

  describe ".h3_resolution" do
    let(:h3_index) { valid_h3_index }
    let(:result) { 8 }

    subject(:h3_resolution) { H3Ruby.h3_resolution(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_base_cell" do
    let(:h3_index) { valid_h3_index }
    let(:result) { 12 }

    subject(:h3_base_cell) { H3Ruby.h3_base_cell(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".origin_from_unidirectional_edge" do
    let(:edge) { "11928308280fffff".to_i(16) }
    let(:result) { "8928308280fffff".to_i(16) }

    subject(:origin_from_unidirectional_edge) { H3Ruby.origin_from_unidirectional_edge(edge) }

    it { is_expected.to eq(result) }
  end

  describe ".destination_from_unidirectional_edge" do
    let(:edge) { "11928308280fffff".to_i(16) }
    let(:result) { "8928308283bffff".to_i(16) }

    subject(:destination_from_unidirectional_edge) { H3Ruby.destination_from_unidirectional_edge(edge) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_distance" do
    let(:origin) { "89283082993ffff".to_i(16) }
    let(:destination) { "89283082827ffff".to_i(16) }
    let(:result) { 5 }

    subject(:h3_distance) { H3Ruby.h3_distance(origin, destination) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_to_parent" do
    let(:h3_index) { "89283082993ffff".to_i(16) }
    let(:parent_resolution) { 8 }
    let(:result) { 698351615 }

    subject(:h3_to_parent) { H3Ruby.h3_to_parent(h3_index, parent_resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".max_h3_to_children_size" do
    let(:h3_index) { "89283082993ffff".to_i(16) }
    let(:child_resolution) { 10 }
    let(:result) { 7 }

    subject(:max_h3_to_children_size) { H3Ruby.max_h3_to_children_size(h3_index, child_resolution) }

    it { is_expected.to eq(result) }
  end
end
