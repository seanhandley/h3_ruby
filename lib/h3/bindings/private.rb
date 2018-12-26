module H3
  module Bindings
    # Private H3 functions which should not be called directly.
    #
    # This module provides bindings that do not have to be invoked directly by clients
    # of the library. They are used only internally to provide related public interface.
    module Private
      extend H3::Bindings::Base

      attach_function :compact, %i[h3_set output_buffer size], :bool
      attach_function :geo_to_h3, :geoToH3, [GeoCoord.by_ref, Resolution], :h3_index
      attach_function :h3_indexes_from_unidirectional_edge,
                      :getH3IndexesFromUnidirectionalEdge,
                      %i[h3_index output_buffer], :void
      attach_function :h3_line, :h3Line, %i[h3_index h3_index output_buffer], :int
      attach_function :h3_unidirectional_edges_from_hexagon,
                      :getH3UnidirectionalEdgesFromHexagon,
                      %i[h3_index output_buffer], :void
      attach_function :h3_set_to_linked_geo,
                      :h3SetToLinkedGeo,
                      [:h3_set, :size, LinkedGeoPolygon.by_ref],
                      :void
      attach_function :h3_to_children, :h3ToChildren, [:h3_index, Resolution, :output_buffer], :void
      attach_function :h3_to_geo, :h3ToGeo, [:h3_index, GeoCoord.by_ref], :void
      attach_function :h3_to_string, :h3ToString, %i[h3_index output_buffer size], :void
      attach_function :h3_to_geo_boundary,
                      :h3ToGeoBoundary,
                      [:h3_index, GeoBoundary.by_ref],
                      :void
      attach_function :h3_unidirectional_edge_boundary,
                      :getH3UnidirectionalEdgeBoundary,
                      %i[h3_index output_buffer], :void
      attach_function :hex_range, :hexRange, %i[h3_index k_distance output_buffer], :bool
      attach_function :hex_range_distances,
                      :hexRangeDistances,
                      %i[h3_index k_distance output_buffer output_buffer], :bool
      attach_function :hex_ranges, :hexRanges, %i[h3_set size k_distance output_buffer], :bool
      attach_function :hex_ring, :hexRing, %i[h3_index k_distance output_buffer], :bool
      attach_function :k_ring, :kRing, %i[h3_index k_distance output_buffer], :void
      attach_function :k_ring_distances,
                      :kRingDistances,
                      %i[h3_index k_distance output_buffer output_buffer],
                      :bool
      attach_function :max_polyfill_size,
                      :maxPolyfillSize,
                      [GeoPolygon.by_ref, Resolution],
                      :int
      attach_function :max_uncompact_size, :maxUncompactSize, [:h3_set, :size, Resolution], :int
      attach_function :polyfill, [GeoPolygon.by_ref, Resolution, :output_buffer], :void
      attach_function :uncompact, [:h3_set, :size, :output_buffer, :size, Resolution], :bool
    end
  end
end
