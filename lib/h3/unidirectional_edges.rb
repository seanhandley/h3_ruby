module H3
  # Unidirectional edge functions
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/unidirectional-edges
  module UnidirectionalEdges
    extend H3::Bindings::Base

    # @!method h3_indexes_neighbors?(origin, destination)
    #
    # Determine whether two H3 indexes are neighbors.
    #
    # @param [Integer] origin Origin H3 index
    # @param [Integer] destination Destination H3 index
    #
    # @example Check two H3 indexes
    #   H3.h3_indexes_neighbors?(617700169958293503, 617700169958031359)
    #   true
    #
    # @return [Boolean] True if indexes are neighbors
    attach_function :h3_indexes_neighbors, :h3IndexesAreNeighbors, %i[h3_index h3_index], :bool

    # @!method h3_unidirectional_edge_valid?(h3_index)
    #
    # Determine whether the given H3 index represents an edge.
    #
    # @param [Integer] h3_index H3 index
    #
    # @example Check if H3 index is a valid unidirectional edge.
    #   H3.h3_unidirectional_edge_valid?(1266218516299644927)
    #   true
    #
    # @return [Boolean] True if H3 index is a valid unidirectional edge
    attach_function :h3_unidirectional_edge_valid,
                    :h3UnidirectionalEdgeIsValid,
                    %i[h3_index],
                    :bool

    # @!method h3_unidirectional_edge(origin, destination)
    #
    # Derives the H3 index of the edge from the given H3 indexes.
    #
    # @param [Integer] origin H3 index
    # @param [Integer] destination H3 index
    #
    # @example Derive the H3 edge index between two H3 indexes
    #   H3.h3_unidirectional_edge(617700169958293503, 617700169958031359)
    #   1626506486489284607
    #
    # @return [Integer] H3 edge index
    attach_function :h3_unidirectional_edge,
                    :getH3UnidirectionalEdge,
                    %i[h3_index h3_index],
                    :h3_index

    # @!method destination_from_unidirectional_edge(edge)
    #
    # Derive destination H3 index from edge.
    #
    # @param [Integer] edge H3 edge index
    #
    # @example Get destination index from edge
    #   H3.destination_from_unidirectional_edge(1266218516299644927)
    #   617700169961177087
    #
    # @return [Integer] H3 index
    attach_function :destination_from_unidirectional_edge,
                    :getDestinationH3IndexFromUnidirectionalEdge,
                    %i[h3_index],
                    :h3_index

    # @!method origin_from_unidirectional_edge(edge)
    #
    # Derive origin H3 index from edge.
    #
    # @param [Integer] edge H3 edge index
    #
    # @example Get origin index from edge
    #   H3.origin_from_unidirectional_edge(1266218516299644927)
    #   617700169958293503
    #
    # @return [Integer] H3 index
    attach_function :origin_from_unidirectional_edge,
                    :getOriginH3IndexFromUnidirectionalEdge,
                    %i[h3_index],
                    :h3_index

    # Derive origin and destination H3 indexes from edge.
    #
    # Returned in the form
    #
    #   [origin, destination]
    #
    # @param [Integer] edge H3 edge index
    #
    # @example Get origin and destination indexes from edge
    #   H3.h3_indexes_from_unidirectional_edge(1266218516299644927)
    #   [617700169958293503, 617700169961177087]
    #
    # @return [Array<Integer>] H3 index array.
    def h3_indexes_from_unidirectional_edge(edge)
      max_hexagons = 2
      origin_destination = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
      Bindings::Private.h3_indexes_from_unidirectional_edge(edge, origin_destination)
      origin_destination.read_array_of_ulong_long(max_hexagons).reject(&:zero?)
    end

    # Derive unidirectional edges for a H3 index.
    #
    # @param [Integer] origin H3 index
    #
    # @example Get unidirectional indexes from hexagon
    #   H3.h3_unidirectional_edges_from_hexagon(1266218516299644927)
    #   [
    #     1266218516299644927, 1338276110337572863, 1410333704375500799,
    #     1482391298413428735, 1554448892451356671, 1626506486489284607
    #   ]
    #
    # @return [Array<Integer>] H3 index array.
    def h3_unidirectional_edges_from_hexagon(origin)
      max_edges = 6
      edges = FFI::MemoryPointer.new(:ulong_long, max_edges)
      Bindings::Private.h3_unidirectional_edges_from_hexagon(origin, edges)
      edges.read_array_of_ulong_long(max_edges).reject(&:zero?)
    end

    # Derive coordinates for edge boundary.
    #
    # @param [Integer] edge H3 edge index
    #
    # @example
    #   H3.h3_unidirectional_edge_boundary(1266218516299644927)
    #   [
    #     [37.77820687262237, -122.41971895414808],
    #     [37.77652420699321, -122.42079024541876]
    #   ]
    #
    # @return [Array<Array<Float>>] Edge boundary coordinates for a hexagon
    def h3_unidirectional_edge_boundary(edge)
      geo_boundary = Bindings::Structs::GeoBoundary.new
      Bindings::Private.h3_unidirectional_edge_boundary(edge, geo_boundary)
      geo_boundary[:verts].take(geo_boundary[:num_verts] * 2).map do |d|
        rads_to_degs(d)
      end.each_slice(2).to_a
    end
  end
end
