RSpec.describe H3 do
  include_context "constants"

  describe ".parent" do
    let(:h3_index) { "89283082993ffff".to_i(16) }
    let(:parent_resolution) { 8 }
    let(:result) { "8828308299fffff".to_i(16) }

    subject(:parent) { H3.parent(h3_index, parent_resolution) }

    it { is_expected.to eq(result) }
  end

  describe ".children" do
    let(:h3_index) { "8928308280fffff".to_i(16) }

    subject(:children) { H3.children(h3_index, child_resolution) }

    context "when resolution is 9" do
      let(:child_resolution) { 9 }
      let(:count) { 1 }
      let(:expected) { "8928308280fffff".to_i(16) }

      it "has 1 child" do
        expect(children.count).to eq count
      end

      it "is the expected value" do
        expect(children.first).to eq expected
      end
    end

    context "when resolution is 10" do
      let(:child_resolution) { 10 }
      let(:count) { 7 }

      it "has 7 children" do
        expect(children.count).to eq count
      end
    end

    context "when resolution is 15" do
      let(:child_resolution) { 15 }
      let(:count) { 117649 }

      it "has 117649 children" do
        expect(children.count).to eq count
      end
    end

    context "when resolution is 3" do
      let(:child_resolution) { 3 }

      it "raises an error" do
        expect { children }.to raise_error(H3::Bindings::Error::ResolutionDomainError)
      end
    end

    context "when the resolution is -1" do
      let(:child_resolution) { -1 }

      it "raises an error" do
        expect { children }.to raise_error(H3::Bindings::Error::ResolutionDomainError)
      end
    end

    context "when the resolution is 16" do
      let(:child_resolution) { 16 }

      it "raises an error" do
        expect { children }.to raise_error(H3::Bindings::Error::ResolutionDomainError)
      end
    end
  end

  describe ".max_children" do
    let(:h3_index) { "8928308280fffff".to_i(16) }

    subject(:max_children) { H3.max_children(h3_index, child_resolution) }

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

    context "when resolution is 3" do
      let(:child_resolution) { 3 }

      it "raises an error" do
        expect { max_children }.to raise_error(H3::Bindings::Error::ResolutionDomainError)
      end
    end

    context "when the resolution is -1" do
      let(:child_resolution) { -1 }

      it "raises an error" do
        expect { max_children }.to raise_error(H3::Bindings::Error::ResolutionDomainError)
      end
    end

    context "when the resolution is 16" do
      let(:child_resolution) { 16 }

      it "raises an error" do
        expect { max_children }.to raise_error(H3::Bindings::Error::ResolutionDomainError)
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
        expect { uncompact }.to raise_error(H3::Bindings::Error::ResolutionMismatchError)
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
        expect { max_uncompact_size }.to raise_error(H3::Bindings::Error::ResolutionMismatchError)
      end
    end
  end

  describe ".center_child" do
    let(:h3_index) { "8828308299fffff".to_i(16) }
    let(:resolution) { 10 }
    let(:result) { "8a2830829807fff".to_i(16) }

    subject(:center_child) { H3.center_child(h3_index, resolution) }

    it { is_expected.to eq result }
  end
end
