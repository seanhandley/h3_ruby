module H3
  # Hierarchical grid functions.
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/hierarchy
  module Hierarchy
    extend H3::Bindings::Base

    # @!method h3_to_parent(h3_index, parent_resolution)
    #
    # Derive the parent hexagon which contains the hexagon at the given H3 index.
    #
    # @param [Integer] h3_index A valid H3 index.
    # @param [Integer] parent_resoluton The desired resolution of the parent hexagon.
    #
    # @example Find the parent hexagon for a H3 Index.
    #   H3.h3_to_parent(613196570357137407, 6)
    #   604189371209351167
    #
    # @return [Integer] H3 Index of parent hexagon.
    attach_function :h3_to_parent, :h3ToParent, [ :h3_index, :int ], :h3_index

    # @!method max_h3_to_children_size(h3_index, child_resolution)
    #
    # Derive maximum number of child hexagons possible at given resolution.
    #
    # @param [Integer] h3_index A valid H3 index.
    # @param [Integer] child_resoluton The desired resolution of the child hexagons.
    #
    # @example Derive maximum number of child hexagons.
    #    H3.max_h3_to_children_size(613196570357137407, 10)
    #    49
    #
    # @return [Integer] Maximum number of child hexagons possible at given resolution.
    attach_function :max_h3_to_children_size, :maxH3ToChildrenSize, [ :h3_index, :int ], :int

    # Derive child hexagons contained within the hexagon at the given H3 Index.
    #
    # @param [Integer] h3_index A valid H3 Index.
    # @param [Integer] child_resolution The desired resolution of hexagons returned.
    #
    # @example Find the child hexagons for a H3 Index.
    #   H3.h3_to_children(613196570357137407, 9)
    #   [
    #     617700169982672895, 617700169982935039, 617700169983197183, 617700169983459327,
    #     617700169983721471, 617700169983983615, 617700169984245759
    #   ]
    #
    # @return [Array<Integer>] H3 indexes of child hexagons.
    def h3_to_children(h3_index, child_resolution)
      max_children = max_h3_to_children_size(h3_index, child_resolution)
      h3_children = FFI::MemoryPointer.new(H3_INDEX, max_children)
      Bindings::Private.h3_to_children(h3_index, child_resolution, h3_children)
      h3_children.read_array_of_ulong_long(max_children).reject(&:zero?)
    end

    # Find the maximum uncompacted size of the given set of H3 indexes.
    #
    # @param [Array<Integer>] compacted_set An array of valid H3 Indexes.
    # @param [Integer] resolution The desired resolution to uncompact to.
    #
    # @example Find the maximum uncompacted size of the given set.
    #   h3_set = [
    #     617700440093229055, 617700440092704767, 617700440100569087, 617700440013012991,
    #     617700440013275135, 617700440092180479, 617700440091656191, 617700440092966911,
    #     617700440100831231, 617700440100044799, 617700440101617663, 617700440081956863,
    #     613196840447246335
    #   ]
    #   H3.max_uncompact_size(h3_set, 10)
    #   133
    #
    # @raise [ArgumentError] Given resolution is invalid for h3_set.
    #
    # @return [Integer] Maximum size of uncompacted set.
    def max_uncompact_size(compacted_set, resolution)
      compacted_set.uniq!
      FFI::MemoryPointer.new(H3_INDEX, compacted_set.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(compacted_set)
        size = Bindings::Private.max_uncompact_size(hexagons_ptr, compacted_set.size, resolution)
        raise(ArgumentError, "Couldn't estimate size. Invalid resolution?") if size < 0
        return size
      end
    end

    # Compact a set of H3 indexes as best as possible.
    #
    # In the case where the set cannot be compacted, the set is returned unchanged.
    #
    # @param [Array<Integer>] h3_set An array of valid H3 Indexes.
    #
    # @example Compact the given set.
    #   h3_set = [
    #     617700440073043967, 617700440072781823, 617700440073568255, 617700440093229055,
    #     617700440092704767, 617700440100569087, 617700440074092543, 617700440073830399,
    #     617700440074354687, 617700440073306111, 617700440013012991, 617700440013275135,
    #     617700440092180479, 617700440091656191, 617700440092966911, 617700440100831231,
    #     617700440100044799, 617700440101617663, 617700440081956863
    #   ]
    #   H3.compact(h3_set)
    #   [
    #     617700440093229055, 617700440092704767, 617700440100569087, 617700440013012991,
    #     617700440013275135, 617700440092180479, 617700440091656191, 617700440092966911,
    #     617700440100831231, 617700440100044799, 617700440101617663, 617700440081956863,
    #     613196840447246335
    #   ]
    #
    # @raise [RuntimeError] Couldn't attempt to compact given H3 indexes.
    #
    # @return [Array<Integer>] Compacted set of H3 Indexes.
    def compact(h3_set)
      h3_set.uniq!
      failure = false
      out = FFI::MemoryPointer.new(H3_INDEX, h3_set.size)
      FFI::MemoryPointer.new(H3_INDEX, h3_set.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(h3_set)
        failure = Bindings::Private.compact(hexagons_ptr, out, h3_set.size)
      end
      
      raise "Couldn't compact given indexes" if failure
      out.read_array_of_ulong_long(h3_set.size).reject(&:zero?)
    end

    # Uncompact a set of H3 indexes to the given resolution.
    #
    # @param [Array<Integer>] compacted_set An array of valid H3 Indexes.
    # @param [Integer] resolution The desired resolution to uncompact to.
    #
    # @example Compact the given set.
    #   h3_set = [
    #     617700440093229055, 617700440092704767, 617700440100569087, 617700440013012991,
    #     617700440013275135, 617700440092180479, 617700440091656191, 617700440092966911,
    #     617700440100831231, 617700440100044799, 617700440101617663, 617700440081956863,
    #     613196840447246335
    #   ]
    #   H3.uncompact(h3_set)
    #   [
    #     617700440093229055, 617700440092704767, 617700440100569087, 617700440013012991,
    #     617700440013275135, 617700440092180479, 617700440091656191, 617700440092966911,
    #     617700440100831231, 617700440100044799, 617700440101617663, 617700440081956863,
    #     617700440072781823, 617700440073043967, 617700440073306111, 617700440073568255,
    #     617700440073830399, 617700440074092543, 617700440074354687
    #   ]
    #
    # @raise [RuntimeError] Couldn't attempt to umcompact H3 indexes.
    #
    # @return [Array<Integer>] Uncompacted set of H3 Indexes.
    def uncompact(compacted_set, resolution)
      max_size = max_uncompact_size(compacted_set, resolution)

      failure = false
      out = FFI::MemoryPointer.new(H3_INDEX, max_size)
      FFI::MemoryPointer.new(H3_INDEX, compacted_set.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(compacted_set)
        failure = Bindings::Private.uncompact(hexagons_ptr, compacted_set.size, out, max_size, resolution)
      end
      
      raise "Couldn't uncompact given indexes" if failure
      out.read_array_of_ulong_long(max_size).reject(&:zero?)
    end
  end
end
