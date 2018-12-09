require "bigdecimal"

RSpec.describe H3Ruby do
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
  end

  describe ".geo_to_h3" do
    let(:resolution) { 8 }
    let(:coords) { [53.959130, -1.079230]}
    subject(:geo_to_h3) { H3Ruby.geo_to_h3(coords, resolution) }

    let(:result) { "8819429a9dfffff".to_i(16) }

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
  end

  describe ".h3_to_geo" do
    let(:h3_index) { "8819429a9dfffff".to_i(16) }
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
  end

  describe ".h3_valid?" do
    let(:h3_index) { "8819429a9dfffff".to_i(16) }
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
  end
end
