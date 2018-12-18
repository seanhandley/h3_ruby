RSpec.describe H3 do
  let(:valid_h3_index) { "8819429a9dfffff".to_i(16) }
  let(:too_long_number) { 10_000_000_000_000_000_000_000 }

  describe ".max_kring_size" do
    let(:k) { 2 }
    let(:result) { 19 }

    subject(:max_kring_size) { H3.max_kring_size(k) }

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

    subject(:geo_to_h3) { H3.geo_to_h3(coords, resolution) }

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
    let(:expected_lat) { 53.95860421941 }
    let(:expected_lon) { -1.08119564709 }

    subject(:h3_to_geo) { H3.h3_to_geo(h3_index) }

    it "should return the expected latitude" do
      expect(h3_to_geo[0]).to be_within(0.000001).of(expected_lat)
    end

    it "should return the expected longitude" do
      expect(h3_to_geo[1]).to be_within(0.000001).of(expected_lon)
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

  describe ".num_hexagons" do
    let(:resolution) { 2 }
    let(:result) { 5882 }

    subject(:num_hexagons) { H3.num_hexagons(resolution) }

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

  describe ".h3_distance" do
    let(:origin) { "89283082993ffff".to_i(16) }
    let(:destination) { "89283082827ffff".to_i(16) }
    let(:result) { 5 }

    subject(:h3_distance) { H3.h3_distance(origin, destination) }

    it { is_expected.to eq(result) }
  end

  describe ".h3_to_parent" do
    let(:h3_index) { "89283082993ffff".to_i(16) }
    let(:parent_resolution) { 8 }
    let(:result) { 698351615 }

    subject(:h3_to_parent) { H3.h3_to_parent(h3_index, parent_resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".max_h3_to_children_size" do
    let(:h3_index) { "89283082993ffff".to_i(16) }
    let(:child_resolution) { 10 }
    let(:result) { 7 }

    subject(:max_h3_to_children_size) { H3.max_h3_to_children_size(h3_index, child_resolution) }

    it { is_expected.to eq(result) }
  end

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

  describe ".string_to_h3" do
    let(:h3_index) { "8928308280fffff"}
    let(:result) { h3_index.to_i(16) }

    subject(:string_to_h3) { H3.string_to_h3(h3_index) }

    it { is_expected.to eq(result) }
  end

  describe ".string_to_h3" do
    let(:h3_index) { "8928308280fffff" }
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

  describe ".max_h3_to_children_size" do
    let(:h3_index) { "8928308280fffff".to_i(16) }

    subject(:h3_to_children) { H3.max_h3_to_children_size(h3_index, child_resolution) }

    context "when resolution is 3" do
      let(:child_resolution) { 3 }
      let(:count) { 0 }

      it { is_expected.to eq(count) }
    end

    context "when resolution is 9" do
      let(:child_resolution) { 9 }
      let(:count) { 1 }

      it { is_expected.to eq(count) }
    end

    context "when resolution is 10" do
      let(:child_resolution) { 10 }
      let(:count) { 7 }

      it { is_expected.to eq(count) }
    end

    context "when resolution is 15" do
      let(:child_resolution) { 15 }
      let(:count) { 117649 }

      it { is_expected.to eq(count) }
    end
  end

  describe ".h3_to_children" do
    let(:h3_index) { "8928308280fffff".to_i(16) }

    subject(:h3_to_children) { H3.h3_to_children(h3_index, child_resolution) }

    context "when resolution is 3" do
      let(:child_resolution) { 3 }
      let(:count) { 0 }

      it "has 0 children" do
        expect(h3_to_children.count).to eq count
      end
    end

    context "when resolution is 9" do
      let(:child_resolution) { 9 }
      let(:count) { 1 }
      let(:expected) { "8928308280fffff".to_i(16) }

      it "has 1 child" do
        expect(h3_to_children.count).to eq count
      end

      it "is the expected value" do
        expect(h3_to_children.first).to eq expected
      end
    end

    context "when resolution is 10" do
      let(:child_resolution) { 10 }
      let(:count) { 7 }

      it "has 7 children" do
        expect(h3_to_children.count).to eq count
      end
    end

    context "when resolution is 15" do
      let(:child_resolution) { 15 }
      let(:count) { 117649 }

      it "has 117649 children" do
        expect(h3_to_children.count).to eq count
      end
    end
  end

  describe ".hex_range" do
    let(:h3_index) { "8928308280fffff".to_i(16) }

    subject(:hex_range) { H3.hex_range(h3_index, k) }

    context "when k range is 1" do
      let(:k) { 1 }
      let(:count) { 7 }
      let(:expected) do
        %w(8928308280fffff 8928308280bffff 89283082873ffff 89283082877ffff
           8928308283bffff 89283082807ffff 89283082803ffff).map { |i| i.to_i(16) }
      end

      it "has 7 hexagons" do
        expect(hex_range.count).to eq count
      end

      it "has the expected hexagons" do
        expect(hex_range).to eq expected
      end
    end

    context "when k range is 2" do
      let(:k) { 2 }
      let(:count) { 19 }

      it "has 19 hexagons" do
        expect(hex_range.count).to eq count
      end
    end

    context "when k range is 10" do
      let(:k) { 10 }
      let(:count) { 331 }

      it "has 331 hexagons" do
        expect(hex_range.count).to eq count
      end
    end

    context "when range contains a pentagon" do
      let(:h3_index) { "821c07fffffffff".to_i(16) }
      let(:k) { 1 }

      it "raises an error" do
        expect { hex_range }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".k_ring" do
    let(:h3_index) { "8928308280fffff".to_i(16) }

    subject(:k_ring) { H3.k_ring(h3_index, k) }

    context "when k range is 1" do
      let(:k) { 1 }
      let(:count) { 7 }
      let(:expected) do
        %w(8928308280fffff 8928308280bffff 89283082873ffff 89283082877ffff
           8928308283bffff 89283082807ffff 89283082803ffff).map { |i| i.to_i(16) }
      end

      it "has 7 hexagons" do
        expect(k_ring.count).to eq count
      end

      it "has the expected hexagons" do
        expect(k_ring).to eq expected
      end
    end

    context "when k range is 2" do
      let(:k) { 2 }
      let(:count) { 19 }

      it "has 19 hexagons" do
        expect(k_ring.count).to eq count
      end
    end

    context "when k range is 10" do
      let(:k) { 10 }
      let(:count) { 331 }

      it "has 331 hexagons" do
        expect(k_ring.count).to eq count
      end
    end
  end

  describe ".hex_ring" do
    let(:h3_index) { "8928308280fffff".to_i(16) }

    subject(:hex_ring) { H3.hex_ring(h3_index, k) }

    context "when k range is 1" do
      let(:k) { 1 }
      let(:count) { 6 }
      let(:expected) do
        %w(89283082803ffff 8928308280bffff 89283082873ffff 89283082877ffff
           8928308283bffff 89283082807ffff).map { |i| i.to_i(16) }
      end

      it "has 6 hexagons" do
        expect(hex_ring.count).to eq count
      end

      it "has the expected hexagons" do
        expect(hex_ring).to eq expected
      end
    end

    context "when k range is 2" do
      let(:k) { 2 }
      let(:count) { 12 }

      it "has 12 hexagons" do
        expect(hex_ring.count).to eq count
      end
    end

    context "when k range is 10" do
      let(:k) { 10 }
      let(:count) { 60 }

      it "has 60 hexagons" do
        expect(hex_ring.count).to eq count
      end
    end
  end

  describe ".origin_and_destination_from_unidirectional_edge" do
    let(:h3_index) { "11928308280fffff".to_i(16) }
    let(:expected_indexes) do
      %w(8928308280fffff 8928308283bffff).map { |i| i.to_i(16) }
    end

    subject(:origin_and_destination_from_unidirectional_edge) do
      H3.origin_and_destination_from_unidirectional_edge(h3_index)
    end

    it "has two expected h3 indexes" do
      expect(origin_and_destination_from_unidirectional_edge).to eq(expected_indexes)
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

  describe ".hex_ranges" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:h3_set) { [h3_index] }
    let(:k) { 1 }
    let(:outer_ring) do
      [
        "8928308280bffff", "89283082807ffff", "89283082877ffff",
        "89283082803ffff", "89283082873ffff", "8928308283bffff"
      ].map { |i| i.to_i(16) }
    end

    subject(:hex_ranges) { H3.hex_ranges(h3_set, k) }

    it "contains a single k/v pair" do
      expect(hex_ranges.count).to eq 1
    end

    it "has one key, the h3_index" do
      expect(hex_ranges.keys.first).to eq h3_index
    end

    it "has two ring sets" do
      expect(hex_ranges[h3_index].count).to eq 2
    end

    it "has an inner ring containing only the original index" do
      expect(hex_ranges[h3_index].first).to eq [h3_index]
    end

    it "has an outer ring containing six indexes" do
      expect(hex_ranges[h3_index].last.count).to eq 6
    end

    it "has an outer ring containing all expected indexes" do
      hex_ranges[h3_index].last.each do |index|
        expect(outer_ring).to include(index)
      end
    end

    context "when there is pentagonal distortion" do
      let(:h3_index) { "821c07fffffffff".to_i(16) }

      it "raises an error" do
        expect { hex_ranges }.to raise_error(ArgumentError)
      end
    end

    context "when k is 2" do
      let(:k) { 2 }

      it "contains 3 rings" do
        expect(hex_ranges[h3_index].count).to eq 3
      end

      it "has an inner ring of size 1" do
        expect(hex_ranges[h3_index][0].count).to eq 1
      end

      it "has a middle ring of size 6" do
        expect(hex_ranges[h3_index][1].count).to eq 6
      end

      it "has an outer ring of size 12" do
        expect(hex_ranges[h3_index][2].count).to eq 12
      end
    end

    context "when compared with the ungrouped version" do
      let(:h3_index2) { "8f19425b6ccd582".to_i(16) }
      let(:h3_index3) { "89283082873ffff".to_i(16) }
      let(:h3_set) { [h3_index, h3_index2, h3_index3]}
      let(:ungrouped) { H3.hex_ranges_ungrouped(h3_set, k) }
      let(:k) { 3 }

      it "has the same elements when we remove grouping" do
        expect(hex_ranges.values.flatten).to eq(ungrouped)
      end
    end
  end

  describe ".h3_to_geo_boundary" do
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

    subject(:h3_to_geo_boundary) { H3.h3_to_geo_boundary(h3_index) }

    it "matches expected boundary coordinates" do
      h3_to_geo_boundary.zip(expected) do |(lat, lon), (exp_lat, exp_lon)|
        expect(lat).to be_within(0.000001).of(exp_lat)
        expect(lon).to be_within(0.000001).of(exp_lon)
      end
    end
  end

  describe ".hex_range_distances" do
    let(:h3_index) { "85283473fffffff".to_i(16) }
    let(:k) { 1 }
    let(:outer_ring) do
      [
        "85283447fffffff", "8528347bfffffff", "85283463fffffff",
        "85283477fffffff", "8528340ffffffff", "8528340bfffffff"
      ].map { |i| i.to_i(16) }
    end

    subject(:hex_range_distances) { H3.hex_range_distances(h3_index, k) }

    it "has two range sets" do
      expect(hex_range_distances.count).to eq 2
    end

    it "has an inner range containing hexagons of distance 0" do
      expect(hex_range_distances[0]).to eq [h3_index]
    end

    it "has an outer range containing hexagons of distance 1" do
      expect(hex_range_distances[1].count).to eq 6
    end

    it "has an outer range containing all expected indexes" do
      hex_range_distances[1].each do |index|
        expect(outer_ring).to include(index)
      end
    end

    context "when there is pentagonal distortion" do
      let(:h3_index) { "821c07fffffffff".to_i(16) }

      it "raises an error" do
        expect { hex_range_distances }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".k_ring_distances" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:k) { 1 }
    let(:outer_ring) do
      [
        "8928308280bffff", "89283082873ffff", "89283082877ffff",
        "8928308283bffff", "89283082807ffff", "89283082803ffff"
      ].map { |i| i.to_i(16) }
    end

    subject(:k_ring_distances) { H3.k_ring_distances(h3_index, k) }

    it "has two ring sets" do
      expect(k_ring_distances.count).to eq 2
    end

    it "has an inner ring containing hexagons of distance 0" do
      expect(k_ring_distances[0]).to eq [h3_index]
    end

    it "has an outer ring containing hexagons of distance 1" do
      expect(k_ring_distances[1].count).to eq 6
    end

    it "has an outer ring containing all expected indexes" do
      k_ring_distances[1].each do |index|
        expect(outer_ring).to include(index)
      end
    end
  end

  describe ".max_uncompact_size" do
    let(:h3_index) { "8928308280fffff".to_i(16) }
    let(:resolution) { 9 }
    let(:result) { 2 }

    subject(:max_uncompact_size) { H3.max_uncompact_size([h3_index, h3_index], resolution) }

    it { is_expected.to eq result }

    context "when resolution is incorrect for index" do
      let(:resolution) { 8 }

      it "raises an error" do
        expect { max_uncompact_size }.to raise_error(RuntimeError)
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

  describe ".compact" do
    let(:h3_index) { "89283470c27ffff".to_i(16) }
    let(:k) { 9 }
    let(:uncompacted) do
      H3.k_ring(h3_index, k)
    end

    subject(:compact) { H3.compact(uncompacted) }

    it "has an uncompacted size of 271" do
      expect(uncompacted.size).to eq 271
    end

    it "has a compacted size of 73" do
      expect(compact.size).to eq 73
    end
  end

  describe ".uncompact" do
    let(:h3_index) { "89283470c27ffff".to_i(16) }
    let(:resolution) { 9 }
    let(:uncompacted) do
      H3.k_ring(h3_index, resolution)
    end
    let(:compacted) do
      H3.compact(uncompacted)
    end

    subject(:uncompact) { H3.uncompact(compacted, resolution) }

    it "has an uncompacted size of 271" do
      expect(uncompact.size).to eq 271
    end

    it "has a compacted size of 73" do
      expect(compacted.size).to eq 73
    end

    context "when resolution is incorrect for index" do
      let(:resolution) { 8 }

      it "raises error" do
        expect { uncompact }.to raise_error(RuntimeError)
      end
    end
  end

end
