RSpec.describe H3 do
  include_context "constants"

  describe ".hexagon_count" do
    let(:resolution) { 2 }
    let(:result) { 5882 }

    subject(:hexagon_count) { H3.hexagon_count(resolution) }

    it { is_expected.to eq(result) }

    context "when given an invalid resolution" do
      let(:resolution) { too_long_number }
      let(:result) { false }

      it "returns the expected result" do
        expect { hexagon_count }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".degs_to_rads" do
    let(:degs) { 100 }
    let(:result) { 1.7453292519943295 }

    subject(:degs_to_rads) { H3.degs_to_rads(degs) }

    it { is_expected.to eq(result) }
  end

  describe ".rads_to_degs" do
    let(:rads) { 1.7453292519943295 }
    let(:result) { 100 }

    subject(:rads_to_degs) { H3.rads_to_degs(rads) }

    it { is_expected.to eq(result) }
  end

  describe ".hex_area_km2" do
    let(:resolution) { 2 }
    let(:result) { 86745.85403 }

    subject(:hex_area_km2) { H3.hex_area_km2(resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".hex_area_m2" do
    let(:resolution) { 2 }
    let(:result) { 86745854035.0 }

    subject(:hex_area_m2) { H3.hex_area_m2(resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".edge_length_km" do
    let(:resolution) { 2 }
    let(:result) { 158.2446558 }

    subject(:edge_length_km) { H3.edge_length_km(resolution) }

    it { is_expected.to eq(result) }
  end
      
  describe ".edge_length_m" do
    let(:resolution) { 2 }
    let(:result) { 158244.6558 }

    subject(:edge_length_m) { H3.edge_length_m(resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".base_cells" do
    let(:count) { 122 }
    subject(:base_cells) { H3.base_cells }

    it "has 122 base cells" do
      expect(base_cells.count).to eq(count)
    end
  end

  describe ".pentagon_count" do
    let(:count) { 12 }
    subject(:pentagon_count) { H3.pentagon_count }

    it "has 12 pentagons per resolution" do
      expect(pentagon_count).to eq(count)
    end
  end

  describe ".pentagons" do
    let(:resolution) { 4 }
    let(:expected) do
      [
        594615896891195391, 594967740612083711,
        595319584332972031, 595812165542215679,
        596199193635192831, 596515852983992319,
        596691774844436479, 597008434193235967,
        597395462286213119, 597888043495456767,
        598239887216345087, 598591730937233407
      ]
    end
    subject(:pentagons) { H3.pentagons(resolution) }

    it "returns pentagons at the given resolution" do
      expect(pentagons).to eq(expected)
    end
  end
end
