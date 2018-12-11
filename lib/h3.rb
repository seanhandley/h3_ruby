require "h3/h3"
require "h3/version"
require 'ffi'

module H3
  extend FFI::Library
  ffi_lib ["libh3", "libh3.1"]
  H3_INDEX = :ulong_long
  PREDICATES = %i(h3_indexes_neighbors h3_pentagon h3_res_class_3 h3_unidirectional_edge_valid h3_valid)

  attach_function :degs_to_rads, :degsToRads, [ :double ], :double
  attach_function :destination_from_unidirectional_edge, :getDestinationH3IndexFromUnidirectionalEdge, [ H3_INDEX ], H3_INDEX
  attach_function :edge_length_km, :edgeLengthKm, [ :int ], :double
  attach_function :edge_length_m, :edgeLengthM, [ :int ], :double
  attach_function :h3_base_cell, :h3GetBaseCell, [ H3_INDEX ], :int
  attach_function :h3_distance, :h3Distance, [ H3_INDEX, H3_INDEX], :int
  attach_function :h3_indexes_neighbors, :h3IndexesAreNeighbors, [ H3_INDEX, H3_INDEX ], :bool
  attach_function :h3_pentagon, :h3IsPentagon, [ H3_INDEX ], :bool
  attach_function :h3_res_class_3, :h3IsResClassIII, [ H3_INDEX ], :bool
  attach_function :h3_resolution, :h3GetResolution, [ H3_INDEX ], :int
  attach_function :h3_to_parent, :h3ToParent, [ H3_INDEX, :int ], :int
  attach_function :h3_unidirectional_edge, :getH3UnidirectionalEdge, [ H3_INDEX, H3_INDEX ], H3_INDEX
  attach_function :h3_unidirectional_edge_valid, :h3UnidirectionalEdgeIsValid, [ H3_INDEX ], :bool
  attach_function :origin_from_unidirectional_edge, :getOriginH3IndexFromUnidirectionalEdge, [ H3_INDEX ], H3_INDEX
  attach_function :h3_valid, :h3IsValid, [ H3_INDEX ], :bool
  attach_function :hex_area_km2, :hexAreaKm2, [ :int ], :double
  attach_function :hex_area_m2, :hexAreaM2, [ :int ], :double
  attach_function :max_h3_to_children_size, :maxH3ToChildrenSize, [ H3_INDEX, :int ], :int
  attach_function :max_kring_size, :maxKringSize, [ :int ], :int
  attach_function :num_hexagons, :numHexagons, [ :int ], H3_INDEX
  attach_function :rads_to_degs, :radsToDegs, [ :double ], :double
  attach_function :string_to_h3, :stringToH3, [ :string ], H3_INDEX

  PREDICATES.each do |predicate|
    singleton_class.send(:alias_method, "#{predicate}?".to_sym, predicate)
  end
end
