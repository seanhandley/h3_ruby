require "h3/h3"
require "h3/version"
require 'ffi'

module H3
  class << self
    def degs_to_rads(degs)
      Function.degsToRads(degs)
    end

    def destination_from_unidirectional_edge(edge)
      Function.getDestinationH3IndexFromUnidirectionalEdge(edge)
    end

    def edge_length_km(resolution)
      Function.edgeLengthKm(resolution)
    end

    def edge_length_m(resolution)
      Function.edgeLengthM(resolution)
    end

    def h3_base_cell(h3_index)
      Function.h3GetBaseCell(h3_index)
    end

    def h3_distance(origin, destination)
      Function.h3Distance(origin, destination)
    end

    def h3_indexes_neighbors?(origin, destination)
      Function.h3IndexesAreNeighbors(origin, destination) != 0
    end

    def h3_pentagon?(h3_index)
      Function.h3IsPentagon(h3_index) != 0
    end

    def h3_res_class_3?(h3_index)
      Function.h3IsResClassIII(h3_index) != 0
    end

    def h3_resolution(h3_index)
      Function.h3GetResolution(h3_index)
    end

    def h3_to_parent(h3_index, parent_resolution)
      Function.h3ToParent(h3_index, parent_resolution)
    end

    def h3_unidirectional_edge(origin, destination)
      Function.getH3UnidirectionalEdge(origin, destination)
    end

    def h3_unidirectional_edge_valid?(edge)
      Function.h3UnidirectionalEdgeIsValid(edge) != 0
    end

    def h3_valid?(h3_index)
      Function.h3IsValid(h3_index) != 0
    end

    def hex_area_km2(resolution)
      Function.hexAreaKm2(resolution)
    end

    def hex_area_m2(resolution)
      Function.hexAreaM2(resolution)
    end

    def max_h3_to_children_size(h3_index, child_resolution)
      Function.maxH3ToChildrenSize(h3_index, child_resolution)
    end

    def max_kring_size(resolution)
      Function.maxKringSize(resolution)
    end

    def num_hexagons(resolution)
      Function.numHexagons(resolution)
    end

    def origin_from_unidirectional_edge(edge)
      Function.getOriginH3IndexFromUnidirectionalEdge(edge)
    end

    def rads_to_degs(degs)
      Function.radsToDegs(degs)
    end

    def string_to_h3(str)
      Function.stringToH3(str)
    end
  end

  module Function
    extend FFI::Library
    ffi_lib ["libh3", "libh3.1"]
    H3_INDEX = :ulong_long

    attach_function :degsToRads, [ :double ], :double
    attach_function :edgeLengthKm, [ :int ], :double
    attach_function :edgeLengthM, [ :int ], :double
    attach_function :getDestinationH3IndexFromUnidirectionalEdge, [ H3_INDEX ], H3_INDEX
    attach_function :getH3UnidirectionalEdge, [ H3_INDEX, H3_INDEX ], H3_INDEX
    attach_function :getOriginH3IndexFromUnidirectionalEdge, [ H3_INDEX ], H3_INDEX
    attach_function :h3Distance, [ H3_INDEX, H3_INDEX], :int
    attach_function :h3GetBaseCell, [ H3_INDEX ], :int
    attach_function :h3GetResolution, [ H3_INDEX ], :int
    attach_function :h3IsResClassIII, [ H3_INDEX ], :int
    attach_function :h3IsPentagon, [ H3_INDEX ], :int
    attach_function :h3IndexesAreNeighbors, [ H3_INDEX, H3_INDEX ], :int
    attach_function :h3IsValid, [ H3_INDEX ], :int
    attach_function :h3ToParent, [ H3_INDEX, :int ], :int
    attach_function :h3UnidirectionalEdgeIsValid, [ H3_INDEX ], :int
    attach_function :hexAreaKm2, [ :int ], :double
    attach_function :hexAreaM2, [ :int ], :double
    attach_function :maxH3ToChildrenSize, [ H3_INDEX, :int ], :int
    attach_function :maxKringSize, [ :int ], :int
    attach_function :numHexagons, [ :int ], H3_INDEX
    attach_function :radsToDegs, [ :double ], :double
    attach_function :stringToH3, [ :string ], H3_INDEX
  end
  private_constant :Function
end
