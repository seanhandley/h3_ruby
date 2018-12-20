RSpec.describe H3 do
  include_context "constants"

  describe ".h3_to_parent" do
    let(:h3_index) { "89283082993ffff".to_i(16) }
    let(:parent_resolution) { 8 }
    let(:result) { "8828308299fffff".to_i(16) }

    subject(:h3_to_parent) { H3.h3_to_parent(h3_index, parent_resolution) }

    it { is_expected.to eq(result) }
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
        expect { uncompact }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".max_uncompact_size" do
    let(:h3_indexes) { ["8928308280fffff", "89283470893ffff"].map { |i| i.to_i(16) } }
    let(:resolution) { 9 }
    let(:result) { 2 }

    subject(:max_uncompact_size) { H3.max_uncompact_size(h3_indexes, resolution) }

    it { is_expected.to eq result }

    context "when resolution is incorrect for index" do
      let(:resolution) { 8 }

      it "raises an error" do
        expect { max_uncompact_size }.to raise_error(ArgumentError)
      end
    end
  end
end
