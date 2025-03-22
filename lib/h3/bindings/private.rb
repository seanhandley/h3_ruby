module H3
  module Bindings
    # Private H3 functions which should not be called directly.
    #
    # This module provides bindings that do not have to be invoked directly by clients
    # of the library. They are used only internally to provide related public interface.
    module Private
      extend H3::Bindings::Base

      def self.safe_call(out_type, method, *in_args)
        out = FFI::MemoryPointer.new(out_type)
        send(method, *in_args + [out]).tap do |code|
          Error::raise_error(code) unless code.zero?
        end
        out.send("read_#{out_type}".to_sym)
      end

      # Hierarchy functions
      attach_function :cellToParent, [:h3_index, Resolution, H3Index], :h3_error_code
      attach_function :compactCells, [H3IndexesIn, H3IndexesOut, :int64], :h3_error_code
      attach_function :h3_to_children, :cellToChildren, [:h3_index, Resolution, H3IndexesOut], :h3_error_code
      attach_function :max_children, :cellToChildrenSize, [:h3_index, Resolution, :pointer], :h3_error_code
      attach_function :max_uncompact_size, :uncompactCellsSize, [H3IndexesIn, :int64, Resolution, :pointer], :h3_error_code
      attach_function :uncompactCells, [H3IndexesIn, :size_t, H3IndexesOut, :size_t, Resolution], :h3_error_code

      # Indexing functions
      attach_function :from_string, :stringToH3, %i[string pointer], :h3_error_code
      attach_function :geo_to_h3, :latLngToCell, [LatLng, Resolution, :pointer], :h3_error_code
      attach_function :h3_to_geo, :cellToLatLng, [:h3_index, LatLng], :h3_error_code
      attach_function :h3_to_string, :h3ToString, %i[h3_index buffer_out size_t], :h3_error_code
      attach_function :h3_to_geo_boundary, :cellToBoundary, [:h3_index, CellBoundary], :h3_error_code

      # Traversal functions
      attach_function :k_ring, :gridDisk, [:h3_index, :k_distance, H3IndexesOut], :h3_error_code
      attach_function :k_ring_distances, :gridDiskDistances, [:h3_index, :k_distance, H3IndexesOut, :pointer], :h3_error_code
      attach_function :hex_range, :gridDiskUnsafe, [:h3_index, :k_distance, H3IndexesOut], :h3_error_code
      attach_function :hex_range_distances, :gridDiskDistancesUnsafe, [:h3_index, :k_distance, H3IndexesOut, :pointer], :h3_error_code
      attach_function :hex_ranges, :gridDisksUnsafe, [H3IndexesIn, :size_t, :k_distance, H3IndexesOut], :h3_error_code
      attach_function :hex_ring, :gridRingUnsafe, [:h3_index, :k_distance, H3IndexesOut], :h3_error_code
      attach_function :h3_line, :gridPathCells, [:h3_index, :h3_index, H3IndexesOut], :h3_error_code
      attach_function :max_kring_size, :maxGridDiskSize, [:k_distance, :pointer], :h3_error_code

      # Directed edge functions (formerly unidirectional_edge)
      attach_function :h3_indexes_from_unidirectional_edge, :directedEdgeToCells, [:h3_index, H3IndexesOut], :h3_error_code
      attach_function :h3_unidirectional_edges_from_hexagon, :originToDirectedEdges, [:h3_index, H3IndexesOut], :h3_error_code
      attach_function :h3_unidirectional_edge_boundary, :directedEdgeToBoundary, [:h3_index, CellBoundary], :h3_error_code

      # Miscellaneous functions
      attach_function :hexagon_count, :getNumCells, [Resolution, :pointer], :h3_error_code
      attach_function :edge_length_km, :getHexagonEdgeLengthAvgKm, [Resolution, :pointer], :h3_error_code
      attach_function :edge_length_m, :getHexagonEdgeLengthAvgM, [Resolution, :pointer], :h3_error_code
      attach_function :h3_faces, :getIcosahedronFaces, %i[h3_index buffer_out], :h3_error_code
      attach_function :max_face_count, :maxFaceCount, %i[h3_index pointer], :h3_error_code
      attach_function :get_pentagon_indexes, :getPentagons, [:int, H3IndexesOut], :h3_error_code
      attach_function :res_0_indexes, :getRes0Cells, [H3IndexesOut], :h3_error_code

      # Distance functions
      attach_function :point_distance_rads, :greatCircleDistanceRads, [LatLng, LatLng], :double
      attach_function :point_distance_km, :greatCircleDistanceKm, [LatLng, LatLng], :double
      attach_function :point_distance_m, :greatCircleDistanceM, [LatLng, LatLng], :double

      # Region functions
      attach_function :destroy_linked_polygon, :destroyLinkedMultiPolygon, [LinkedGeoPolygon], :void
      attach_function :h3_set_to_linked_geo, :cellsToLinkedMultiPolygon, [H3IndexesIn, :size_t, LinkedGeoPolygon], :h3_error_code
      attach_function :max_polyfill_size, :maxPolygonToCellsSize, [GeoPolygon, Resolution, :pointer], :h3_error_code
      attach_function :polyfill, :polygonToCells, [GeoPolygon, Resolution, H3IndexesOut], :h3_error_code
    end
  end
end