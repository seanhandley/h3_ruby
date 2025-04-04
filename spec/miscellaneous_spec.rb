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
        expect { hexagon_count }.to raise_error(H3::Bindings::Error::ResolutionDomainError)
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

  # describe ".hex_area_km2" do
  #   let(:resolution) { 2 }
  #   let(:result) { 86801.7803989972 }

  #   subject(:hex_area_km2) { H3.hex_area_km2(resolution) }

  #   it { is_expected.to eq(result) }
  # end

  # describe ".hex_area_m2" do
  #   let(:resolution) { 2 }
  #   let(:result) { 86801780398.99731 }

  #   subject(:hex_area_m2) { H3.hex_area_m2(resolution) }

  #   it { is_expected.to eq(result) }
  # end

  describe ".edge_length_km" do
    let(:resolution) { 2 }
    let(:result) { 182.5129565 }

    subject(:edge_length_km) { H3.edge_length_km(resolution) }

    it { is_expected.to eq(result) }
  end
      
  # describe ".edge_length_m" do
  #   let(:resolution) { 2 }
  #   let(:result) { 158244.6558 }

  #   subject(:edge_length_m) { H3.edge_length_m(resolution) }

  #   it { is_expected.to eq(result) }
  # end

  describe ".base_cells" do
    let(:count) { 122 }
    subject(:base_cells) { H3.base_cells }

    it "has 122 base cells" do
      expect(base_cells.count).to eq(count)
    end
  end

  # describe ".pentagon_count" do
  #   let(:count) { 12 }
  #   subject(:pentagon_count) { H3.pentagon_count }

  #   it "has 12 pentagons per resolution" do
  #     expect(pentagon_count).to eq(count)
  #   end
  # end

  # describe ".pentagons" do
  #   let(:resolution) { 4 }
  #   let(:expected) do
  #     [
  #       594615896891195391, 594967740612083711,
  #       595319584332972031, 595812165542215679,
  #       596199193635192831, 596515852983992319,
  #       596691774844436479, 597008434193235967,
  #       597395462286213119, 597888043495456767,
  #       598239887216345087, 598591730937233407
  #     ]
  #   end
  #   subject(:pentagons) { H3.pentagons(resolution) }

  #   it "returns pentagons at the given resolution" do
  #     expect(pentagons).to eq(expected)
  #   end
  # end

  # describe ".cell_area_rads2" do
  #   let(:cell) { "8928308280fffff".to_i(16) }
  #   let(:expected) { 2.6952182709835757e-09 }
  #   subject(:cell_area_rads2) { H3.cell_area_rads2(cell) }

  #   it "returns cell area in rads2" do
  #     expect(cell_area_rads2).to be_within(0.0001).of(expected)
  #   end
  # end

  # describe ".cell_area_km2" do
  #   let(:cell) { "8928308280fffff".to_i(16) }
  #   let(:expected) { 0.10939818864648902 }
  #   subject(:cell_area_km2) { H3.cell_area_km2(cell) }

  #   it "returns cell area in km2" do
  #     expect(cell_area_km2).to be_within(0.0001).of(expected)
  #   end
  # end

  # describe ".cell_area_m2" do
  #   let(:cell) { "8928308280fffff".to_i(16) }
  #   let(:expected) { 109398.18864648901 }
  #   subject(:cell_area_m2) { H3.cell_area_m2(cell) }

  #   it "returns cell area in m2" do
  #     expect(cell_area_m2).to be_within(0.0001).of(expected)
  #   end
  # end

  # describe ".exact_edge_length_rads" do
  #   let(:cell) { "11928308280fffff".to_i(16) }
  #   let(:expected) { 3.287684056071637e-05 }
  #   subject(:exact_edge_length_rads) { H3.exact_edge_length_rads(cell) }

  #   it "returns edge length in rads" do
  #     expect(exact_edge_length_rads).to be_within(0.0001).of(expected)
  #   end
  # end

  # describe ".exact_edge_length_km" do
  #   let(:cell) { "11928308280fffff".to_i(16) }
  #   let(:expected) { 0.20945858729823577 }
  #   subject(:exact_edge_length_km) { H3.exact_edge_length_km(cell) }

  #   it "returns edge length in km" do
  #     expect(exact_edge_length_km).to be_within(0.0001).of(expected)
  #   end
  # end

  # describe ".exact_edge_length_m" do
  #   let(:cell) { "11928308280fffff".to_i(16) }
  #   let(:expected) { 209.45858729823578 }
  #   subject(:exact_edge_length_m) { H3.exact_edge_length_m(cell) }

  #   it "returns edge length in m" do
  #     expect(exact_edge_length_m).to be_within(0.0001).of(expected)
  #   end
  # end

  # describe ".point_distance_rads" do
  #   let(:a) { [41.3964809, 2.160444] }
  #   let(:b) { [41.3870609, 2.164917] }
  #   let(:expected) { 0.00017453024784008713 }
  #   subject(:point_distance_rads) { H3.point_distance_rads(a, b) }

  #   it "returns distance between points in rads" do
  #     expect(point_distance_rads).to be_within(0.0001).of(expected)
  #   end

  #   context "when the coordinates are invalid" do
  #     let(:a) { [91, -18] }

  #     it "raises an argument error" do
  #       expect { point_distance_rads }.to raise_error(ArgumentError)
  #     end
  #   end
  # end

  # describe ".point_distance_km" do
  #   let(:a) { [41.3964809, 2.160444] }
  #   let(:b) { [41.3870609, 2.164917] }
  #   let(:expected) { 1.1119334622766763 }
  #   subject(:point_distance_km) { H3.point_distance_km(a, b) }

  #   it "returns distance between points in km" do
  #     expect(point_distance_km).to be_within(0.0001).of(expected)
  #   end

  #   context "when the coordinates are invalid" do
  #     let(:a) { [89, -181] }

  #     it "raises an argument error" do
  #       expect { point_distance_km }.to raise_error(ArgumentError)
  #     end
  #   end
  # end

  # describe ".point_distance_m" do
  #   let(:a) { [41.3964809, 2.160444] }
  #   let(:b) { [41.3870609, 2.164917] }
  #   let(:expected) { 1111.9334622766764 }
  #   subject(:point_distance_m) { H3.point_distance_m(a, b) }

  #   it "returns distance between points in m" do
  #     expect(point_distance_m).to be_within(0.0001).of(expected)
  #   end

  #   context "when the coordinates are invalid" do
  #     let(:a) { "boom" }

  #     it "raises an argument error" do
  #       expect { point_distance_m }.to raise_error(ArgumentError)
  #     end
  #   end
  # end
end
