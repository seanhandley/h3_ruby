RSpec.describe H3 do
  include_context "constants"

  describe ".h3_indexes_neighbors?" do
    let(:origin) { "8928308280fffff".to_i(16) }
    let(:destination) { "8928308280bffff".to_i(16) }
    let(:result) { true }

    subject(:h3_indexes_neighbors?) { H3.h3_indexes_neighbors?(origin, destination) }

    it { is_expected.to eq(result) }

    context "when the indexes aren't neighbors" do
      let(:destination) { "89283082993ffff".to_i(16) }
      let(:result) { false }

      it { is_expected.to eq(result) }
    end
  end

  describe ".h3_unidirectional_edge" do
    let(:origin) { "8928308280fffff".to_i(16) }
    let(:destination) { "8928308280bffff".to_i(16) }
    let(:result) { "16928308280fffff".to_i(16) }

    subject(:h3_unidirectional_edge) { H3.h3_unidirectional_edge(origin, destination) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_unidirectional_edge_valid?" do
    let(:edge) { "11928308280fffff".to_i(16) }
    let(:result) { true }

    subject(:h3_unidirectional_edge_valid?) { H3.h3_unidirectional_edge_valid?(edge) }

    it { is_expected.to eq(result) }

    context "when the h3 index is not a valid unidirectional edge" do
      let(:edge) { "8928308280fffff".to_i(16) }
      let(:result) { false }

      it { is_expected.to eq(result) }
    end
  end

  describe ".origin_from_unidirectional_edge" do
    let(:edge) { "11928308280fffff".to_i(16) }
    let(:result) { "8928308280fffff".to_i(16) }

    subject(:origin_from_unidirectional_edge) { H3.origin_from_unidirectional_edge(edge) }

    it { is_expected.to eq(result) }
  end

  describe ".destination_from_unidirectional_edge" do
    let(:edge) { "11928308280fffff".to_i(16) }
    let(:result) { "8928308283bffff".to_i(16) }

    subject(:destination_from_unidirectional_edge) { H3.destination_from_unidirectional_edge(edge) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_indexes_from_unidirectional_edge" do
    let(:h3_index) { "11928308280fffff".to_i(16) }
    let(:expected_indexes) do
      %w(8928308280fffff 8928308283bffff).map { |i| i.to_i(16) }
    end

    subject(:h3_indexes_from_unidirectional_edge) do
      H3.h3_indexes_from_unidirectional_edge(h3_index)
    end

    it "has two expected h3 indexes" do
      expect(h3_indexes_from_unidirectional_edge).to eq(expected_indexes)
    end
  end

  describe ".h3_unidirectional_edges_from_hexagon" do
    subject(:h3_unidirectional_edges_from_hexagon) do
      H3.h3_unidirectional_edges_from_hexagon(h3_index)
    end

    context "when index is a hexagon" do
      let(:h3_index) { "8928308280fffff".to_i(16) }
      let(:count) { 6 }

      it "has six expected edges" do
        expect(h3_unidirectional_edges_from_hexagon.count).to eq(count)
      end
    end

    context "when index is a pentagon" do
      let(:h3_index) { "821c07fffffffff".to_i(16) }
      let(:count) { 5 }

      it "has five expected edges" do
        expect(h3_unidirectional_edges_from_hexagon.count).to eq(count)
      end
    end
  end

  describe ".h3_unidirectional_edge_boundary" do
    let(:edge) { "11928308280fffff".to_i(16) }
    let(:expected) do
      [[37.77820687262237, -122.41971895414808], [37.77652420699321, -122.42079024541876]]
    end

    subject(:h3_unidirectional_edge_boundary) { H3.h3_unidirectional_edge_boundary(edge) }

    it "matches expected coordinates" do
      h3_unidirectional_edge_boundary.zip(expected) do |(lat, lon), (exp_lat, exp_lon)|
        expect(lat).to be_within(0.000001).of(exp_lat)
        expect(lon).to be_within(0.000001).of(exp_lon)
      end
    end
  end
end
