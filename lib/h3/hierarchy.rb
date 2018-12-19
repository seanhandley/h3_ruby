module H3
  module Hierarchy
    extend H3::BindingBase

    attach_function :h3_to_parent, :h3ToParent, [ :h3_index, :int ], :int

    def h3_to_children(h3_index, child_resolution)
      max_children = max_h3_to_children_size(h3_index, child_resolution)
      h3_children = FFI::MemoryPointer.new(H3_INDEX, max_children)
      Bindings::Private.h3_to_children(h3_index, child_resolution, h3_children)
      h3_children.read_array_of_ulong_long(max_children).reject(&:zero?)
    end

    def max_uncompact_size(hexagons, resolution)
      FFI::MemoryPointer.new(H3_INDEX, hexagons.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(hexagons)
        size = Bindings::Private.max_uncompact_size(hexagons_ptr, hexagons.size, resolution)
        raise "Couldn't estimate size. Invalid resolution?" if size < 0
        return size
      end
    end

    def compact(hexagons)
      failure = false
      out = FFI::MemoryPointer.new(H3_INDEX, hexagons.size)
      FFI::MemoryPointer.new(H3_INDEX, hexagons.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(hexagons)
        failure = Bindings::Private.compact(hexagons_ptr, out, hexagons.size)
      end
      
      raise "Couldn't compact given indexes" if failure
      out.read_array_of_ulong_long(hexagons.size).reject(&:zero?)
    end

    def uncompact(compacted, resolution)
      max_size = max_uncompact_size(compacted, resolution)

      failure = false
      out = FFI::MemoryPointer.new(H3_INDEX, max_size)
      FFI::MemoryPointer.new(H3_INDEX, compacted.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(compacted)
        failure = Bindings::Private.uncompact(hexagons_ptr, compacted.size, out, max_size, resolution)
      end
      
      raise "Couldn't uncompact given indexes" if failure
      out.read_array_of_ulong_long(max_size).reject(&:zero?)
    end
  end
end
