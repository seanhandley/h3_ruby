module H3
  module Traversal
    extend H3::BindingBase

    attach_function :max_kring_size, :maxKringSize, [ :int ], :int
    attach_function :h3_distance, :h3Distance, [ :h3_index, :h3_index], :int

    def hex_range(h3_index, k)
      max_hexagons = max_kring_size(k)
      hexagons = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
      pentagonal_distortion = Bindings::Private.hex_range(h3_index, k, hexagons)
      raise(ArgumentError, "Specified hexagon range contains a pentagon") if pentagonal_distortion
      hexagons.read_array_of_ulong_long(max_hexagons).reject(&:zero?)
    end

    def k_ring(h3_index, k)
      max_hexagons = max_kring_size(k)
      hexagons = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
      Bindings::Private.k_ring(h3_index, k, hexagons)
      hexagons.read_array_of_ulong_long(max_hexagons).reject(&:zero?)
    end

    def hex_ring(h3_index, k)
      max_hexagons = max_hex_ring_size(k)
      hexagons = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
      pentagonal_distortion = Bindings::Private.hex_ring(h3_index, k, hexagons)
      raise(ArgumentError, "The hex ring contains a pentagon") if pentagonal_distortion
      hexagons.read_array_of_ulong_long(max_hexagons).reject(&:zero?)
    end

    def max_hex_ring_size(k)
      k.zero? ? 1 : 6 * k
    end

    def hex_ranges(h3_set, k, grouped: true)
      h3_range_indexes = hex_ranges_ungrouped(h3_set, k)
      return h3_range_indexes unless grouped
      out = {}
      h3_range_indexes.each_slice(max_kring_size(k)).each do |indexes|
        h3_index = indexes.first

        out[h3_index] = 0.upto(k).map do |j|
          start  = j == 0 ? 0 : max_kring_size(j-1)
          length = max_hex_ring_size(j)
          indexes.slice(start, length)
        end
      end
      out
    end

    def hex_range_distances(h3_index, k)
      max_out_size = max_kring_size(k)
      out = FFI::MemoryPointer.new(H3_INDEX, max_out_size)
      distances = FFI::MemoryPointer.new(:int, max_out_size)
      pentagonal_distortion = Bindings::Private.hex_range_distances(h3_index, k, out, distances)
      raise(ArgumentError, "Specified hexagon range contains a pentagon") if pentagonal_distortion

      hexagons = out.read_array_of_ulong_long(max_out_size)
      distances = distances.read_array_of_int(max_out_size)

      Hash[
        distances.zip(hexagons).group_by(&:first).map { |d, hs| [d, hs.map(&:last)] }
      ]
    end

    def k_ring_distances(h3_index, k)
      max_out_size = max_kring_size(k)
      out = FFI::MemoryPointer.new(H3_INDEX, max_out_size)
      distances = FFI::MemoryPointer.new(:int, max_out_size)
      Bindings::Private.k_ring_distances(h3_index, k, out, distances)

      hexagons = out.read_array_of_ulong_long(max_out_size)
      distances = distances.read_array_of_int(max_out_size)

      Hash[
        distances.zip(hexagons).group_by(&:first).map { |d, hs| [d, hs.map(&:last)] }
      ]
    end

    private

    def hex_ranges_ungrouped(h3_set, k)
      h3_set.uniq!
      max_out_size = h3_set.size * max_kring_size(k)
      out = FFI::MemoryPointer.new(H3_INDEX, max_out_size)
      pentagonal_distortion = false
      FFI::MemoryPointer.new(H3_INDEX, h3_set.size) do |h3_set_ptr|
        h3_set_ptr.write_array_of_ulong_long(h3_set)
        pentagonal_distortion = Bindings::Private.hex_ranges(h3_set_ptr, h3_set.size, k, out)
      end
      raise(ArgumentError, "One of the specified hexagon ranges contains a pentagon") if pentagonal_distortion

      out.read_array_of_ulong_long(max_out_size)
    end
  end
end
