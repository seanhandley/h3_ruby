require "h3/structs"

require 'ffi'

module H3
  extend FFI::Library
  ffi_lib ["libh3", "libh3.1"]
  H3_INDEX = :ulong_long
  H3_TO_STR_BUF_SIZE = 32

  PREDICATES = %i(h3_indexes_neighbors h3_pentagon h3_res_class_3
                  h3_unidirectional_edge_valid h3_valid).freeze

  attach_function :degs_to_rads, :degsToRads, [ :double ], :double
  attach_function :destination_from_unidirectional_edge,
                  :getDestinationH3IndexFromUnidirectionalEdge,
                  [ H3_INDEX ],
                  H3_INDEX
  attach_function :edge_length_km, :edgeLengthKm, [ :int ], :double
  attach_function :edge_length_m, :edgeLengthM, [ :int ], :double
  attach_function :geoToH3, [ Structs::GeoCoord.by_ref, :int ], H3_INDEX
  attach_function :h3_base_cell, :h3GetBaseCell, [ H3_INDEX ], :int
  attach_function :h3_distance, :h3Distance, [ H3_INDEX, H3_INDEX], :int
  attach_function :h3_indexes_neighbors, :h3IndexesAreNeighbors, [ H3_INDEX, H3_INDEX ], :bool
  attach_function :h3_pentagon, :h3IsPentagon, [ H3_INDEX ], :bool
  attach_function :h3_res_class_3, :h3IsResClassIII, [ H3_INDEX ], :bool
  attach_function :h3_resolution, :h3GetResolution, [ H3_INDEX ], :int
  attach_function :h3ToGeo, [ H3_INDEX, :pointer ], :void
  attach_function :h3_to_parent, :h3ToParent, [ H3_INDEX, :int ], :int
  attach_function :h3ToString, [ H3_INDEX, :pointer, :int], :void
  attach_function :h3_unidirectional_edge,
                  :getH3UnidirectionalEdge,
                  [ H3_INDEX, H3_INDEX ],
                  H3_INDEX
  attach_function :h3_unidirectional_edge_valid,
                  :h3UnidirectionalEdgeIsValid,
                  [ H3_INDEX ],
                  :bool
  attach_function :origin_from_unidirectional_edge,
                  :getOriginH3IndexFromUnidirectionalEdge,
                  [ H3_INDEX ],
                  H3_INDEX
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

  def self.geo_to_h3(coords, resolution)
    raise TypeError unless coords.is_a?(Array)
    raise ArgumentError unless coords.count == 2
    raise RangeError if coords.any? { |d| d > 1000000 }

    lat, lon = coords
    coords = Structs::GeoCoord.new
    coords[:lat] = degs_to_rads(lat)
    coords[:lon] = degs_to_rads(lon)
    geoToH3(coords, resolution)
  end

  def self.h3_to_geo(h3_index)
    coords = Structs::GeoCoord.new
    h3ToGeo(h3_index, coords.pointer)
    [rads_to_degs(coords[:lat]), rads_to_degs(coords[:lon])]
  end

  def self.h3_to_string(h3_index)
    h3_str = FFI::MemoryPointer.new(:char, H3_TO_STR_BUF_SIZE)
    h3ToString(h3_index, h3_str, H3_TO_STR_BUF_SIZE)
    h3_str.read_string 
  end
end
