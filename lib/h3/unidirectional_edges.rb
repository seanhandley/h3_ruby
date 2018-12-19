module H3
  module UnidirectionalEdges
    extend H3::BindingBase

    attach_function :h3_indexes_neighbors, :h3IndexesAreNeighbors, [ :h3_index, :h3_index ], :bool
    attach_function :h3_unidirectional_edge_valid,
                :h3UnidirectionalEdgeIsValid,
                [ :h3_index ],
                :bool
    attach_function :h3_unidirectional_edge,
                    :getH3UnidirectionalEdge,
                    [ :h3_index, :h3_index ],
                    :h3_index

    attach_function :destination_from_unidirectional_edge,
                    :getDestinationH3IndexFromUnidirectionalEdge,
                    [ :h3_index ],
                    :h3_index
    attach_function :origin_from_unidirectional_edge,
                    :getOriginH3IndexFromUnidirectionalEdge,
                    [ :h3_index ],
                    :h3_index

    def h3_indexes_from_unidirectional_edge(edge)
      max_hexagons = 2
      origin_destination = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
      Bindings::Private.h3_indexes_from_unidirectional_edge(edge, origin_destination)
      origin_destination.read_array_of_ulong_long(max_hexagons).reject { |i| i == 0 }
    end

    def h3_unidirectional_edges_from_hexagon(origin)
      max_edges = 6
      edges = FFI::MemoryPointer.new(:ulong_long, max_edges)
      Bindings::Private.h3_unidirectional_edges_from_hexagon(origin, edges)
      edges.read_array_of_ulong_long(max_edges).reject { |i| i == 0 }
    end

    def h3_unidirectional_edge_boundary(edge)
      geo_boundary = Bindings::Structs::GeoBoundary.new
      Bindings::Private.h3_unidirectional_edge_boundary(edge, geo_boundary)
      geo_boundary[:verts].take(geo_boundary[:num_verts] * 2).map do |d|
        rads_to_degs(d)
      end.each_slice(2).to_a
    end
  end
end
