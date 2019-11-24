RSpec.describe H3 do
  include_context "constants"

  describe ".polyfill" do
    let(:geojson) do
      File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury_without_holes.json"))
    end
    let(:resolution) { 9 }
    let(:expected_count) { 14_369 }

    subject(:polyfill) { H3.polyfill(geojson, resolution) }

    it "has the correct number of hexagons" do
      expect(polyfill.count).to eq expected_count
    end

    context "when banbury area has two holes in it" do
      let(:geojson) do
        File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury.json"))
      end
      let(:expected_count) { 13_526 }

      it "has fewer hexagons" do
        expect(polyfill.count).to eq expected_count
      end
    end

    context "when polyfilling australia" do
      let(:geojson) do
        File.read(File.join(File.dirname(__FILE__), "support/fixtures/australia.json"))
      end
      let(:expect_count) { 92 }

      it "has the correct number of hexagons" do
        expect(polyfill.count).to eq expect_count
      end
    end
  end

  describe ".max_polyfill_size" do
    let(:geojson) do
      File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury.json"))
    end
    let(:resolution) { 9 }
    let(:expected_count) { 75_367 }

    subject(:max_polyfill_size) { H3.max_polyfill_size(geojson, resolution) }

    it "has the correct number of hexagons" do
      expect(max_polyfill_size).to eq expected_count
    end
  end

  describe ".h3_set_to_linked_geo" do
    let(:geojson) do
      File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury.json"))
    end
    let(:resolution) { 8 }
    let(:hexagons) { H3.polyfill(geojson, resolution) }

    subject(:h3_set_to_linked_geo) { H3.h3_set_to_linked_geo(hexagons) }
    
    it "has 3 outlines" do
      h3_set_to_linked_geo.count == 3
    end

    it "can be converted to GeoJSON" do
      expect(H3.coordinates_to_geo_json(h3_set_to_linked_geo)).to be_truthy
    end
  end
end
