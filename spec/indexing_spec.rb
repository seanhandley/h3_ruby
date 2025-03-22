require "spec_helper"

RSpec.describe H3 do
  include_context "constants"

  describe ".from_geo_coordinates" do
    let(:resolution) { 8 }
    let(:coords) { [53.959130, -1.079230]}
    let(:result) { valid_h3_index }

    subject(:from_geo_coordinates) { H3.from_geo_coordinates(coords, resolution) }

    it { is_expected.to eq(result) }

    context "when given more than 2 values" do
      let(:coords) { [1, 2, 3] }

      it "raises an error" do
        expect { from_geo_coordinates }.to raise_error(ArgumentError)
      end
    end

    context "when given a non array" do
      let(:coords) { "boom" }

      it "raises an error" do
        expect { from_geo_coordinates }.to raise_error(ArgumentError)
      end
    end

    context "when given bad coordinates" do
      let(:coords) { [-1.1323222, 190.1020102] }

      it "raises an error" do
        expect { from_geo_coordinates }.to raise_error(ArgumentError)
      end
    end    
  end

  describe ".to_geo_coordinates" do
    let(:h3_index) { valid_h3_index }
    let(:expected_lat) { 53.95860421941 }
    let(:expected_lon) { -1.08119564709 }

    subject(:to_geo_coordinates) { H3.to_geo_coordinates(h3_index) }

    it "should return the expected latitude" do
      expect(to_geo_coordinates[0]).to be_within(0.000001).of(expected_lat)
    end

    it "should return the expected longitude" do
      expect(to_geo_coordinates[1]).to be_within(0.000001).of(expected_lon)
    end

    context "when given an invalid h3_index" do
      let(:h3_index) { "boom" }

      it "raises an error" do
        expect { to_geo_coordinates }.to raise_error(TypeError)
      end
    end

    context "when given an index that's too large" do
      let(:h3_index) { too_long_number }

      it "raises an error" do
        expect { to_geo_coordinates }.to raise_error(RangeError)
      end
    end
  end

  describe ".to_boundary" do
    let(:h3_index) { "85283473fffffff".to_i(16) }
    let(:expected) do
      [
        [37.2713558667319, -121.91508032705622],
        [37.353926450852256, -121.8622232890249],
        [37.42834118609435, -121.92354999630156],
        [37.42012867767779, -122.03773496427027],
        [37.33755608435299, -122.090428929044],
        [37.26319797461824, -122.02910130918998]
      ]
    end

    subject(:to_boundary) { H3.to_boundary(h3_index) }

    it "matches expected boundary coordinates" do
      to_boundary.zip(expected) do |(lat, lon), (exp_lat, exp_lon)|
        expect(lat).to be_within(0.000001).of(exp_lat)
        expect(lon).to be_within(0.000001).of(exp_lon)
      end
    end
  end
end
