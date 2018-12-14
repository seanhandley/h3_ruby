require "h3/structs"
require "ffi"

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
  attach_function :getH3IndexesFromUnidirectionalEdge, [ H3_INDEX, :pointer ], :void
  attach_function :getH3UnidirectionalEdgesFromHexagon, [ H3_INDEX, :pointer ], :void
  attach_function :h3_base_cell, :h3GetBaseCell, [ H3_INDEX ], :int
  attach_function :h3_distance, :h3Distance, [ H3_INDEX, H3_INDEX], :int
  attach_function :h3_indexes_neighbors, :h3IndexesAreNeighbors, [ H3_INDEX, H3_INDEX ], :bool
  attach_function :h3_pentagon, :h3IsPentagon, [ H3_INDEX ], :bool
  attach_function :h3_res_class_3, :h3IsResClassIII, [ H3_INDEX ], :bool
  attach_function :h3_resolution, :h3GetResolution, [ H3_INDEX ], :int
  attach_function :h3_valid, :h3IsValid, [ H3_INDEX ], :bool
  attach_function :h3ToChildren, [ H3_INDEX, :int, :pointer ], :void
  attach_function :h3ToGeo, [ H3_INDEX, Structs::GeoCoord.by_ref ], :void
  attach_function :h3_to_parent, :h3ToParent, [ H3_INDEX, :int ], :int
  attach_function :h3ToString, [ H3_INDEX, :pointer, :int], :void
  attach_function :h3ToGeoBoundary, [H3_INDEX, Structs::GeoBoundary.by_ref ], :void
  attach_function :h3_unidirectional_edge,
                  :getH3UnidirectionalEdge,
                  [ H3_INDEX, H3_INDEX ],
                  H3_INDEX
  attach_function :h3_unidirectional_edge_valid,
                  :h3UnidirectionalEdgeIsValid,
                  [ H3_INDEX ],
                  :bool
  attach_function :getH3UnidirectionalEdgeBoundary, [H3_INDEX, :pointer], :void  
  attach_function :hexRange, [ H3_INDEX, :int, :pointer ], :bool
  attach_function :hexRangeDistances, [H3_INDEX, :int, :pointer, :pointer], :bool
  attach_function :hexRanges, [ :pointer, :int, :int, :pointer ], :bool
  attach_function :hexRing, [H3_INDEX, :int, :pointer], :void
  attach_function :hex_area_km2, :hexAreaKm2, [ :int ], :double
  attach_function :hex_area_m2, :hexAreaM2, [ :int ], :double
  attach_function :kRing, [H3_INDEX, :int, :pointer], :void
  attach_function :kRingDistances, [H3_INDEX, :int, :pointer, :pointer], :bool
  attach_function :max_h3_to_children_size, :maxH3ToChildrenSize, [ H3_INDEX, :int ], :int
  attach_function :max_kring_size, :maxKringSize, [ :int ], :int
  attach_function :maxUncompactSize, [:pointer, :int, :int], :int
  attach_function :num_hexagons, :numHexagons, [ :int ], H3_INDEX
  attach_function :origin_from_unidirectional_edge,
                  :getOriginH3IndexFromUnidirectionalEdge,
                  [ H3_INDEX ],
                  H3_INDEX
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
    h3ToGeo(h3_index, coords)
    [rads_to_degs(coords[:lat]), rads_to_degs(coords[:lon])]
  end

  def self.h3_to_string(h3_index)
    h3_str = FFI::MemoryPointer.new(:char, H3_TO_STR_BUF_SIZE)
    h3ToString(h3_index, h3_str, H3_TO_STR_BUF_SIZE)
    h3_str.read_string 
  end

  def self.h3_to_children(h3_index, child_resolution)
    max_children = max_h3_to_children_size(h3_index, child_resolution)
    h3_children = FFI::MemoryPointer.new(:ulong_long, max_children)
    h3ToChildren(h3_index, child_resolution, h3_children)
    h3_children.read_array_of_ulong_long(max_children).reject { |i| i == 0 }
  end

  def self.hex_range(h3_index, k)
    max_hexagons = max_kring_size(k)
    hexagons = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
    pentagonal_distortion = hexRange(h3_index, k, hexagons)
    raise(ArgumentError, "Specified hexagon range contains a pentagon") if pentagonal_distortion
    hexagons.read_array_of_ulong_long(max_hexagons).reject { |i| i == 0 }
  end

  def self.k_ring(h3_index, k)
    max_hexagons = max_kring_size(k)
    hexagons = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
    kRing(h3_index, k, hexagons)
    hexagons.read_array_of_ulong_long(max_hexagons).reject { |i| i == 0 }
  end

  def self.hex_ring(h3_index, k)
    max_hexagons = max_kring_size(k)
    hexagons = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
    hexRing(h3_index, k, hexagons)
    hexagons.read_array_of_ulong_long(max_hexagons).reject { |i| i == 0 }
  end

  def self.origin_and_destination_from_unidirectional_edge(edge)
    max_hexagons = 2
    origin_destination = FFI::MemoryPointer.new(:ulong_long, max_hexagons)
    getH3IndexesFromUnidirectionalEdge(edge, origin_destination)
    origin_destination.read_array_of_ulong_long(max_hexagons).reject { |i| i == 0 }
  end

  def self.h3_unidirectional_edges_from_hexagon(origin)
    max_edges = 6
    edges = FFI::MemoryPointer.new(:ulong_long, max_edges)
    getH3UnidirectionalEdgesFromHexagon(origin, edges)
    edges.read_array_of_ulong_long(max_edges).reject { |i| i == 0 }
  end

  def self.h3_to_geo_boundary(h3_index)
    geo_boundary = Structs::GeoBoundary.new
    h3ToGeoBoundary(h3_index, geo_boundary)
    geo_boundary[:verts].take(geo_boundary[:num_verts] * 2).map do |d|
      rads_to_degs(d)
    end.each_slice(2).to_a
  end

  def self.hex_ranges(h3_set, k)
    h3_set.uniq!
    max_out_size = h3_set.size * max_kring_size(k)
    out = FFI::MemoryPointer.new(H3_INDEX, max_out_size)
    pentagonal_distortion = false
    FFI::MemoryPointer.new(H3_INDEX, h3_set.size) do |h3_set_ptr|
      h3_set_ptr.write_array_of_ulong_long(h3_set)
      pentagonal_distortion = hexRanges(h3_set_ptr, h3_set.size, k, out)
    end
    raise(ArgumentError, "One of the specified hexagon ranges contains a pentagon") if pentagonal_distortion

    h3_range_indexes = out.read_array_of_ulong_long(max_out_size)
    out = h3_set.inject({}) { |acc, i| acc[i] = []; acc }
    h3_set.each_with_index do |h3_index, i|
      (k + 1).times { out[h3_index] << [] }
      0.upto(h3_set.count * max_kring_size(k) / h3_set.count).map do |j|
        ring_index = ((1 + Math.sqrt(1 + 8 * (j / 6.0).ceil)) / 2).floor - 1
        out[h3_index][ring_index] << h3_range_indexes[(i * h3_set.count + j)]
        out[h3_index][ring_index].compact!
      end
      out[h3_index] = out[h3_index].sort_by(&:count)
    end
    out
  end

  def self.hex_range_distances(h3_index, k)
    max_out_size = max_kring_size(k)
    out = FFI::MemoryPointer.new(H3_INDEX, max_out_size)
    distances = FFI::MemoryPointer.new(:int, max_out_size)
    pentagonal_distortion = hexRangeDistances(h3_index, k, out, distances)
    raise(ArgumentError, "Specified hexagon range contains a pentagon") if pentagonal_distortion

    hexagons = out.read_array_of_ulong_long(max_out_size)
    distances = distances.read_array_of_int(max_out_size)

    Hash[
      distances.zip(hexagons).group_by { |distance, _hexagon| distance }.map do |k, v|
        [k, v.map { |_distance, hexagon| hexagon }]
      end
    ]
  end

  def self.k_ring_distances(h3_index, k)
    max_out_size = max_kring_size(k)
    out = FFI::MemoryPointer.new(H3_INDEX, max_out_size)
    distances = FFI::MemoryPointer.new(:int, max_out_size)
    kRingDistances(h3_index, k, out, distances)

    hexagons = out.read_array_of_ulong_long(max_out_size)
    distances = distances.read_array_of_int(max_out_size)

    Hash[
      distances.zip(hexagons).group_by { |distance, _hexagon| distance }.map do |k, v|
        [k, v.map { |_distance, hexagon| hexagon }]
      end
    ]
  end

  def self.max_uncompact_size(hexagons, resolution)
    FFI::MemoryPointer.new(H3_INDEX, hexagons.size) do |hexagons_ptr|
      hexagons_ptr.write_array_of_ulong_long(hexagons)
      return maxUncompactSize(hexagons_ptr, hexagons.size, resolution)
    end
  end

  def self.h3_unidirectional_edge_boundary(edge)
    geo_boundary = Structs::GeoBoundary.new
    getH3UnidirectionalEdgeBoundary(edge, geo_boundary)
    geo_boundary[:verts].take(geo_boundary[:num_verts] * 2).map do |d|
      rads_to_degs(d)
    end.each_slice(2).to_a
  end
end
