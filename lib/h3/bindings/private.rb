module H3
  module Bindings
    # Private H3 functions which should not be called directly.
    #
    # This module provides bindings that do not have to be invoked directly by clients
    # of the library. They are used only internally to provide related public interface.
    module Private
      extend H3::Bindings::Base

      attach_function :compact, %i[pointer pointer int], :bool
      attach_function :geo_to_h3, :geoToH3, [Bindings::Structs::GeoCoord.by_ref, :int], :h3_index
      attach_function :h3_indexes_from_unidirectional_edge,
                      :getH3IndexesFromUnidirectionalEdge,
                      %i[h3_index pointer], :void
      attach_function :h3_unidirectional_edges_from_hexagon,
                      :getH3UnidirectionalEdgesFromHexagon,
                      %i[h3_index pointer], :void
      attach_function :h3_set_to_linked_geo,
                      :h3SetToLinkedGeo,
                      [:pointer, :int, Bindings::Structs::LinkedGeoPolygon.by_ref],
                      :void
      attach_function :h3_to_children, :h3ToChildren, %i[h3_index int pointer], :void
      attach_function :h3_to_geo, :h3ToGeo, [:h3_index, Bindings::Structs::GeoCoord.by_ref], :void
      attach_function :h3_to_string, :h3ToString, %i[h3_index pointer int], :void
      attach_function :h3_to_geo_boundary,
                      :h3ToGeoBoundary,
                      [:h3_index, Bindings::Structs::GeoBoundary.by_ref],
                      :void
      attach_function :h3_unidirectional_edge_boundary,
                      :getH3UnidirectionalEdgeBoundary,
                      %i[h3_index pointer], :void
      attach_function :hex_range, :hexRange, %i[h3_index int pointer], :bool
      attach_function :hex_range_distances,
                      :hexRangeDistances,
                      %i[h3_index int pointer pointer], :bool
      attach_function :hex_ranges, :hexRanges, %i[pointer int int pointer], :bool
      attach_function :hex_ring, :hexRing, %i[h3_index int pointer], :bool
      attach_function :k_ring, :kRing, %i[h3_index int pointer], :void
      attach_function :k_ring_distances,
                      :kRingDistances,
                      %i[h3_index int pointer pointer],
                      :bool
      attach_function :max_polyfill_size,
                      :maxPolyfillSize,
                      [Bindings::Structs::GeoPolygon.by_ref, :int],
                      :int
      attach_function :max_uncompact_size, :maxUncompactSize, %i[pointer int int], :int
      attach_function :polyfill, %i[pointer int pointer], :void
      attach_function :uncompact, %i[pointer int pointer int int], :bool
    end
  end
end
