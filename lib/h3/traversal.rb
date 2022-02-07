module H3
  # Grid traversal functions
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/traversal
  module Traversal
    extend H3::Bindings::Base

    # @!method max_kring_size(k)
    #
    # Derive the maximum k-ring size for distance k.
    #
    # @param [Integer] k K value.
    #
    # @example Derive the maximum k-ring size for k=5
    #   H3.max_kring_size(5)
    #   91
    #
    # @return [Integer] Maximum k-ring size.
    attach_function :max_kring_size, :maxGridDiskSize, %i[k_distance pointer], :h3_error_code

    # @!method distance(origin, h3_index)
    #
    # Derive the distance between two H3 indexes.
    #
    # @param [Integer] origin Origin H3 index
    # @param [Integer] h3_index H3 index
    #
    # @example Derive the distance between two H3 indexes.
    #   H3.distance(617700169983721471, 617700169959866367)
    #   5
    #
    # @return [Integer] Distance between indexes.
    attach_function :distance, :gridDistance, %i[h3_index h3_index], :k_distance

    # @!method line_size(origin, destination)
    #
    # Derive the number of hexagons present in a line between two H3 indexes.
    #
    # This value is simply `h3_distance(origin, destination) + 1` when a line is computable.
    #
    # Returns a negative number if a line cannot be computed e.g.
    # a pentagon was encountered, or the hexagons are too far apart.
    #
    # @param [Integer] origin Origin H3 index
    # @param [Integer] destination H3 index
    #
    # @example Derive the number of hexagons present in a line between two H3 indexes.
    #   H3.line_size(617700169983721471, 617700169959866367)
    #   6
    #
    # @return [Integer] Number of hexagons found between indexes.
    attach_function :line_size, :gridPathCellsSize, %i[h3_index h3_index], :int

    # Derives H3 indexes within k distance of the origin H3 index.
    #
    # Similar to {k_ring}, except that an error is raised when one of the indexes
    # returned is a pentagon or is in the pentagon distortion area.
    #
    # k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0
    # and all neighboring indexes, and so on.
    #
    # Output is inserted into the array in order of increasing distance from the origin.
    #
    # @param [Integer] origin Origin H3 index
    # @param [Integer] k K distance.
    #
    # @example Derive the hex range for a given H3 index with k of 0.
    #   H3.hex_range(617700169983721471, 0)
    #   [617700169983721471]
    #
    # @example Derive the hex range for a given H3 index with k of 1.
    #   H3.hex_range(617700169983721471, 1)
    #   [
    #     617700169983721471, 617700170047946751, 617700169984245759,
    #     617700169982672895, 617700169983983615, 617700170044276735,
    #     617700170044014591
    #   ]
    #
    # @raise [ArgumentError] Raised if the range contains a pentagon.
    #
    # @return [Array<Integer>] Array of H3 indexes within the k-range.
    def hex_range(origin, k)
      max_hexagons = max_kring_size(k)
      out = H3Indexes.of_size(max_hexagons)
      pentagonal_distortion = Bindings::Private.hex_range(origin, k, out)
      raise(ArgumentError, "Specified hexagon range contains a pentagon") if pentagonal_distortion
      out.read
    end

    # Derives H3 indexes within k distance of the origin H3 index.
    #
    # k-ring 0 is defined as the origin index, k-ring 1 is defined as k-ring 0
    # and all neighboring indexes, and so on.
    #
    # @param [Integer] origin Origin H3 index
    # @param [Integer] k K distance.
    #
    # @example Derive the k-ring for a given H3 index with k of 0.
    #   H3.k_ring(617700169983721471, 0)
    #   [617700169983721471]
    #
    # @example Derive the k-ring for a given H3 index with k of 1.
    #   H3.k_ring(617700169983721471, 1)
    #   [
    #     617700169983721471, 617700170047946751, 617700169984245759,
    #     617700169982672895, 617700169983983615, 617700170044276735,
    #     617700170044014591
    #   ]
    #
    # @return [Array<Integer>] Array of H3 indexes within the k-range.
    def k_ring(origin, k)
      out = FFI::MemoryPointer.new(:int64)
      max_kring_size(k, out).tap do |code|
        Bindings::Error::raise_error(code) unless code.zero?
      end
      out = H3Indexes.of_size(out.read_int64)
      Bindings::Private.k_ring(origin, k, out).tap do |code|
        Bindings::Error::raise_error(code) unless code.zero?
      end
      out.read
    end

    # Derives the hollow hexagonal ring centered at origin with sides of length k.
    #
    # An error is raised when one of the indexes returned is a pentagon or is
    # in the pentagon distortion area.
    #
    # @param [Integer] origin Origin H3 index.
    # @param [Integer] k K distance.
    #
    # @example Derive the hex ring for the H3 index at k = 1
    #   H3.hex_ring(617700169983721471, 1)
    #   [
    #     617700170044014591, 617700170047946751, 617700169984245759,
    #     617700169982672895, 617700169983983615, 617700170044276735
    #   ]
    #
    # @raise [ArgumentError] Raised if the hex ring contains a pentagon.
    #
    # @return [Array<Integer>] Array of H3 indexes within the hex ring.
    def hex_ring(origin, k)
      max_hexagons = max_hex_ring_size(k)
      out = H3Indexes.of_size(max_hexagons)
      pentagonal_distortion = Bindings::Private.hex_ring(origin, k, out)
      raise(ArgumentError, "The hex ring contains a pentagon") if pentagonal_distortion
      out.read
    end

    # Derive the maximum hex ring size for a given distance k.
    #
    # NOTE: This method is not part of the H3 API and is added to this binding for convenience.
    #
    # @param [Integer] k K distance.
    #
    # @example Derive maximum hex ring size for k distance 6.
    #   H3.max_hex_ring_size(6)
    #   36
    #
    # @return [Integer] Maximum hex ring size.
    def max_hex_ring_size(k)
      k.zero? ? 1 : 6 * k
    end

    # Derives H3 indexes within k distance for each H3 index in the set.
    #
    # @param [Array<Integer>] h3_set Set of H3 indexes
    # @param [Integer] k K distance.
    # @param [Boolean] grouped Whether to group the output. Default true.
    #
    # @example Derive the hex ranges for a given H3 set with k of 0.
    #   H3.hex_ranges([617700169983721471, 617700169982672895], 1)
    #   {
    #     617700169983721471 => [
    #       [617700169983721471],
    #       [
    #         617700170047946751, 617700169984245759, 617700169982672895,
    #         617700169983983615, 617700170044276735, 617700170044014591
    #       ]
    #     ],
    #     617700169982672895 = > [
    #       [617700169982672895],
    #       [
    #         617700169984245759, 617700169983197183, 617700169983459327,
    #         617700169982935039, 617700169983983615, 617700169983721471
    #       ]
    #     ]
    #   }
    #
    # @example Derive the hex ranges for a given H3 set with k of 0 ungrouped.
    #   H3.hex_ranges([617700169983721471, 617700169982672895], 1, grouped: false)
    #   [
    #     617700169983721471, 617700170047946751, 617700169984245759,
    #     617700169982672895, 617700169983983615, 617700170044276735,
    #     617700170044014591, 617700169982672895, 617700169984245759,
    #     617700169983197183, 617700169983459327, 617700169982935039,
    #     617700169983983615, 617700169983721471
    #   ]
    #
    # @raise [ArgumentError] Raised if any of the ranges contains a pentagon.
    #
    # @see #hex_range
    #
    # @return [Hash] Hash of H3 index keys, with array values grouped by k-ring.
    def hex_ranges(h3_set, k, grouped: true)
      h3_range_indexes = hex_ranges_ungrouped(h3_set, k)
      return h3_range_indexes unless grouped
      h3_range_indexes.each_slice(max_kring_size(k)).each_with_object({}) do |indexes, out|
        h3_index = indexes.first

        out[h3_index] = k_rings_for_hex_range(indexes, k)
      end
    end

    # Derives the hex range for the given origin at k distance, sub-grouped by distance.
    #
    # @param [Integer] origin Origin H3 index.
    # @param [Integer] k K distance.
    #
    # @example Derive hex range at distance 2
    #   H3.hex_range_distances(617700169983721471, 2)
    #   {
    #     0 => [617700169983721471],
    #     1 = >[
    #       617700170047946751, 617700169984245759, 617700169982672895,
    #       617700169983983615, 617700170044276735, 617700170044014591
    #     ],
    #     2 => [
    #       617700170048995327, 617700170047684607, 617700170048471039,
    #       617700169988177919, 617700169983197183, 617700169983459327,
    #       617700169982935039, 617700175096053759, 617700175097102335,
    #       617700170043752447, 617700170043490303, 617700170045063167
    #     ]
    #   }
    #
    # @raise [ArgumentError] Raised when the hex range contains a pentagon.
    #
    # @return [Hash] Hex range grouped by distance.
    def hex_range_distances(origin, k)
      max_out_size = max_kring_size(k)
      out = H3Indexes.of_size(max_out_size)
      distances = FFI::MemoryPointer.new(:int, max_out_size)
      pentagonal_distortion = Bindings::Private.hex_range_distances(origin, k, out, distances)
      raise(ArgumentError, "Specified hexagon range contains a pentagon") if pentagonal_distortion

      hexagons = out.read
      distances = distances.read_array_of_int(max_out_size)

      Hash[
        distances.zip(hexagons).group_by(&:first).map { |d, hs| [d, hs.map(&:last)] }
      ]
    end

    # Derives the k-ring for the given origin at k distance, sub-grouped by distance.
    #
    # @param [Integer] origin Origin H3 index.
    # @param [Integer] k K distance.
    #
    # @example Derive k-ring at distance 2
    #   H3.k_ring_distances(617700169983721471, 2)
    #   {
    #     0 => [617700169983721471],
    #     1 = >[
    #       617700170047946751, 617700169984245759, 617700169982672895,
    #       617700169983983615, 617700170044276735, 617700170044014591
    #     ],
    #     2 => [
    #       617700170048995327, 617700170047684607, 617700170048471039,
    #       617700169988177919, 617700169983197183, 617700169983459327,
    #       617700169982935039, 617700175096053759, 617700175097102335,
    #       617700170043752447, 617700170043490303, 617700170045063167
    #     ]
    #   }
    #
    # @return [Hash] Hash of k-ring distances grouped by distance.
    def k_ring_distances(origin, k)
      max_out_size = max_kring_size(k)
      out = H3Indexes.of_size(max_out_size)
      distances = FFI::MemoryPointer.new(:int, max_out_size)
      Bindings::Private.k_ring_distances(origin, k, out, distances)

      hexagons = out.read
      distances = distances.read_array_of_int(max_out_size)

      Hash[
        distances.zip(hexagons).group_by(&:first).map { |d, hs| [d, hs.map(&:last)] }
      ]
    end

    # Derives the H3 indexes found in a line between an origin H3 index
    # and a destination H3 index (inclusive of origin and destination).
    #
    # @param [Integer] origin Origin H3 index.
    # @param [Integer] destination Destination H3 index.
    #
    # @example Derive the indexes found in a line.
    #   H3.line(617700169983721471, 617700169959866367)
    #   [
    #     617700169983721471, 617700169984245759, 617700169988177919,
    #     617700169986867199, 617700169987391487, 617700169959866367
    #   ]
    #
    # @raise [ArgumentError] Could not compute line
    #
    # @return [Array<Integer>] H3 indexes
    def line(origin, destination)
      max_hexagons = line_size(origin, destination)
      hexagons = H3Indexes.of_size(max_hexagons)
      res = Bindings::Private.h3_line(origin, destination, hexagons)
      raise(ArgumentError, "Could not compute line") if res.negative?
      hexagons.read
    end

    private

    def k_rings_for_hex_range(indexes, k)
      0.upto(k).map do |j|
        start  = j.zero? ? 0 : max_kring_size(j - 1)
        length = max_hex_ring_size(j)
        indexes.slice(start, length)
      end
    end

    def hex_ranges_ungrouped(h3_set, k)
      h3_set = H3Indexes.with_contents(h3_set)
      max_out_size = h3_set.size * max_kring_size(k)
      out = H3Indexes.of_size(max_out_size)
      if Bindings::Private.hex_ranges(h3_set, h3_set.size, k, out)
        raise(ArgumentError, "One of the specified hexagon ranges contains a pentagon")
      end

      out.read
    end
  end
end
