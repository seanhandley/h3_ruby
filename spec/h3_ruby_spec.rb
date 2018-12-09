require "bigdecimal"

RSpec.describe H3Ruby do
  let(:valid_h3_index) { "8819429a9dfffff".to_i(16) }
  let(:too_long_number) { 10_000_000_000_000_000_000_000 }

  describe ".max_kring_size" do
    subject(:max_kring_size) { H3Ruby.max_kring_size(k) }

    let(:k) { 2 }
    let(:result) { 19 }

    it "returns the expected result" do
      expect(max_kring_size).to eq(result)
    end

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
    subject(:geo_to_h3) { H3Ruby.geo_to_h3(coords, resolution) }

    let(:result) { valid_h3_index }

    it "returns the expected result" do
      expect(geo_to_h3).to eq(result)
    end

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
    subject(:h3_to_geo) { H3Ruby.h3_to_geo(h3_index) }

    let(:result) { [53.95860421941974, -1.081195647095136] }

    it "returns the expected result" do
      expect(h3_to_geo).to eq(result)
    end

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
    subject(:h3_valid?) { H3Ruby.h3_valid?(h3_index) }

    let(:result) { true }

    it "returns the expected result" do
      expect(h3_valid?).to eq(result)
    end

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
    subject(:num_hexagons) { H3Ruby.num_hexagons(resolution) }

    let(:result) { 5882 }

    it "returns the expected result" do
      expect(num_hexagons).to eq(result)
    end

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
    subject(:degs_to_rads) { H3Ruby.degs_to_rads(degs) }

    let(:result) { 1.7453292519943295 }

    it "returns the expected result" do
      expect(degs_to_rads).to eq(result)
    end
  end

  describe ".rads_to_degs" do
    let(:rads) { 1.7453292519943295 }
    subject(:rads_to_degs) { H3Ruby.rads_to_degs(rads) }

    let(:result) { 100 }

    it "returns the expected result" do
      expect(rads_to_degs).to eq(result)
    end
  end

  describe ".hex_area_km2" do
    let(:resolution) { 2 }
    subject(:hex_area_km2) { H3Ruby.hex_area_km2(resolution) }

    let(:result) { 86745.85403 }

    it "returns the expected result" do
      expect(hex_area_km2).to eq(result)
    end
  end

  describe ".hex_area_m2" do
    let(:resolution) { 2 }
    subject(:hex_area_m2) { H3Ruby.hex_area_m2(resolution) }

    let(:result) { 86745854035.0 }

    it "returns the expected result" do
      expect(hex_area_m2).to eq(result)
    end
  end

  describe ".edge_length_km" do
    let(:resolution) { 2 }
    subject(:edge_length_km) { H3Ruby.edge_length_km(resolution) }

    let(:result) { 158.2446558 }

    it "returns the expected result" do
      expect(edge_length_km).to eq(result)
    end
  end
      
  describe ".edge_length_m" do
    let(:resolution) { 2 }
    subject(:edge_length_m) { H3Ruby.edge_length_m(resolution) }

    let(:result) { 158244.6558 }

    it "returns the expected result" do
      expect(edge_length_m).to eq(result)
    end
  end

  describe ".h3_res_class_3?" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    subject(:h3_res_class_3) { H3Ruby.h3_res_class_3?(h3_index) }

    let(:result) { true }

    it "returns the expected result" do
      expect(h3_res_class_3).to eq(result)
    end

    context "when the h3 index is not class III" do
      let(:h3_index) { "8828308280fffff".to_i(16) }

      let(:result) { false }

      it "returns the expected result" do
        expect(h3_res_class_3).to eq(result)
      end   
    end
  end

  describe ".h3_pentagon?" do
    let(:h3_index) { "821c07fffffffff".to_i(16) }
    subject(:h3_pentagon?) { H3Ruby.h3_pentagon?(h3_index) }

    let(:result) { true }

    it "returns the expected result" do
      expect(h3_pentagon?).to eq(result)
    end

    context "when the h3 index is not a pentagon" do
      let(:h3_index) { "8928308280fffff".to_i(16) }

      let(:result) { false }

      it "returns the expected result" do
        expect(h3_pentagon?).to eq(result)
      end   
    end
  end

  describe ".h3_unidirectional_edge_valid?" do
    let(:edge) { "11928308280fffff".to_i(16) }
    subject(:h3_unidirectional_edge_valid?) { H3Ruby.h3_unidirectional_edge_valid?(edge) }

    let(:result) { true }

    it "returns the expected result" do
      expect(h3_unidirectional_edge_valid?).to eq(result)
    end

    context "when the h3 index is not a valid unidirectional edge" do
      let(:edge) { "8928308280fffff".to_i(16) }

      let(:result) { false }

      it "returns the expected result" do
        expect(h3_unidirectional_edge_valid?).to eq(result)
      end   
    end
  end

  describe ".h3_resolution" do
    let(:h3_index) { valid_h3_index }
    subject(:h3_resolution) { H3Ruby.h3_resolution(h3_index) }

    let(:result) { 8 }

    it "returns the expected result" do
      expect(h3_resolution).to eq(result)
    end
  end

  describe ".h3_base_cell" do
    let(:h3_index) { valid_h3_index }
    subject(:h3_base_cell) { H3Ruby.h3_base_cell(h3_index) }

    let(:result) { 12 }

    it "returns the expected result" do
      expect(h3_base_cell).to eq(result)
    end
  end
end
