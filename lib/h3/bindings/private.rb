module H3
  module Bindings
    # Private H3 functions which should not be called directly.
    #
    # This module provides bindings that do not have to be invoked directly by clients
    # of the library. They are used only internally to provide related public interface.
    module Private
      extend H3::Bindings::Base

      attach_function :compact, [H3IndexesIn, H3IndexesOut, :size], :bool
      attach_function :destroy_linked_polygon, :destroyLinkedPolygon, [LinkedGeoPolygon], :void
      attach_function :geo_to_h3, :geoToH3, [GeoCoord, Resolution], :h3_index
      attach_function :h3_indexes_from_unidirectional_edge,
                      :getH3IndexesFromUnidirectionalEdge,
                      [:h3_index, H3IndexesOut], :void
      attach_function :h3_line, :h3Line, [:h3_index, :h3_index, H3IndexesOut], :int
      attach_function :h3_unidirectional_edges_from_hexagon,
                      :getH3UnidirectionalEdgesFromHexagon,
                      [:h3_index, H3IndexesOut], :void
      attach_function :h3_set_to_linked_geo,
                      :h3SetToLinkedGeo,
                      [H3IndexesIn, :size, LinkedGeoPolygon],
                      :void
      attach_function :h3_to_children, :h3ToChildren, [:h3_index, Resolution, H3IndexesOut], :void
      attach_function :h3_to_geo, :h3ToGeo, [:h3_index, GeoCoord], :void
      attach_function :h3_to_string, :h3ToString, %i[h3_index output_buffer size], :void
      attach_function :h3_to_geo_boundary,
                      :h3ToGeoBoundary,
                      [:h3_index, GeoBoundary],
                      :void
      attach_function :h3_unidirectional_edge_boundary,
                      :getH3UnidirectionalEdgeBoundary,
                      [:h3_index, GeoBoundary], :void
      attach_function :hex_range, :hexRange, [:h3_index, :k_distance, H3IndexesOut], :bool
      attach_function :hex_range_distances,
                      :hexRangeDistances,
                      [:h3_index, :k_distance, H3IndexesOut, :output_buffer], :bool
      attach_function :hex_ranges,
                      :hexRanges,
                      [H3IndexesIn, :size, :k_distance, H3IndexesOut],
                      :bool
      attach_function :hex_ring, :hexRing, [:h3_index, :k_distance, H3IndexesOut], :bool
      attach_function :k_ring, :kRing, [:h3_index, :k_distance, H3IndexesOut], :void
      attach_function :k_ring_distances,
                      :kRingDistances,
                      [:h3_index, :k_distance, H3IndexesOut, :output_buffer],
                      :bool
      attach_function :max_polyfill_size,
                      :maxPolyfillSize,
                      [GeoPolygon, Resolution],
                      :int
      attach_function :max_uncompact_size, :maxUncompactSize, [H3IndexesIn, :size, Resolution], :int
      attach_function :polyfill, [GeoPolygon, Resolution, H3IndexesOut], :void
      attach_function :res_0_indexes, :getRes0Indexes, [H3IndexesOut], :void
      attach_function :uncompact, [H3IndexesIn, :size, H3IndexesOut, :size, Resolution], :bool
    end
  end
end
