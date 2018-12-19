require "h3/structs"
require "ffi"
require "rgeo/geo_json"

module H3
  extend FFI::Library
  ffi_lib ["libh3", "libh3.1"]
  H3_INDEX = :ulong_long
  H3_TO_STR_BUF_SIZE = 32

  PREDICATES = %i(h3_indexes_neighbors h3_pentagon h3_res_class_3
                  h3_unidirectional_edge_valid h3_valid).freeze

  attach_function :_compact, :compact, [:pointer, :pointer, :int], :bool
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
  attach_function :h3SetToLinkedGeo, [ :pointer, :int, Structs::LinkedGeoPolygon.by_ref ], :void
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
  attach_function :maxPolyfillSize, [Structs::GeoPolygon.by_ref, :int], :int
  attach_function :maxUncompactSize, [:pointer, :int, :int], :int
  attach_function :num_hexagons, :numHexagons, [ :int ], H3_INDEX
  attach_function :origin_from_unidirectional_edge,
                  :getOriginH3IndexFromUnidirectionalEdge,
                  [ H3_INDEX ],
                  H3_INDEX
  attach_function :_polyfill, :polyfill, [ :pointer, :int, :pointer ], :void
  attach_function :rads_to_degs, :radsToDegs, [ :double ], :double
  attach_function :string_to_h3, :stringToH3, [ :string ], H3_INDEX
  attach_function :_uncompact, :uncompact, [:pointer, :int, :pointer, :int, :int], :bool

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

  def self.max_hex_ring_size(k)
    k.zero? ? 1 : 6*k
  end

  def self.hex_ranges(h3_set, k)
    h3_range_indexes = hex_ranges_ungrouped(h3_set, k)
    out = {}
    h3_range_indexes.each_slice(max_kring_size(k)).each do |indexes|
      h3_index = indexes.first

      out[h3_index] = 0.upto(k).map do |j|
        start  = j == 0 ? 0 : max_kring_size(j-1)
        length = max_hex_ring_size(j)
        indexes.slice(start, length)
      end
    end
    out
  end

  def self.hex_ranges_ungrouped(h3_set, k)
    max_out_size = h3_set.size * max_kring_size(k)
    out = FFI::MemoryPointer.new(H3_INDEX, max_out_size)
    pentagonal_distortion = false
    FFI::MemoryPointer.new(H3_INDEX, h3_set.size) do |h3_set_ptr|
      h3_set_ptr.write_array_of_ulong_long(h3_set)
      pentagonal_distortion = hexRanges(h3_set_ptr, h3_set.size, k, out)
    end
    raise(ArgumentError, "One of the specified hexagon ranges contains a pentagon") if pentagonal_distortion

    out.read_array_of_ulong_long(max_out_size)
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
      distances.zip(hexagons).group_by(&:first).map { |d, hs| [d, hs.map(&:last)] }
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
      distances.zip(hexagons).group_by(&:first).map { |d, hs| [d, hs.map(&:last)] }
    ]
  end

  def self.max_uncompact_size(hexagons, resolution)
    FFI::MemoryPointer.new(H3_INDEX, hexagons.size) do |hexagons_ptr|
      hexagons_ptr.write_array_of_ulong_long(hexagons)
      size = maxUncompactSize(hexagons_ptr, hexagons.size, resolution)
      raise "Couldn't estimate size. Invalid resolution?" if size < 0
      return size
    end
  end

  def self.h3_unidirectional_edge_boundary(edge)
    geo_boundary = Structs::GeoBoundary.new
    getH3UnidirectionalEdgeBoundary(edge, geo_boundary)
    geo_boundary[:verts].take(geo_boundary[:num_verts] * 2).map do |d|
      rads_to_degs(d)
    end.each_slice(2).to_a
  end

  def self.compact(hexagons)
    failure = false
    out = FFI::MemoryPointer.new(H3_INDEX, hexagons.size)
    FFI::MemoryPointer.new(H3_INDEX, hexagons.size) do |hexagons_ptr|
      hexagons_ptr.write_array_of_ulong_long(hexagons)
      failure = _compact(hexagons_ptr, out, hexagons.size)
    end
    
    raise "Couldn't compact given indexes" if failure
    out.read_array_of_ulong_long(hexagons.size).reject(&:zero?)
  end

  def self.uncompact(compacted, resolution)
    max_size = max_uncompact_size(compacted, resolution)

    failure = false
    out = FFI::MemoryPointer.new(H3_INDEX, max_size)
    FFI::MemoryPointer.new(H3_INDEX, compacted.size) do |hexagons_ptr|
      hexagons_ptr.write_array_of_ulong_long(compacted)
      failure = _uncompact(hexagons_ptr, compacted.size, out, max_size, resolution)
    end
    
    raise "Couldn't uncompact given indexes" if failure
    out.read_array_of_ulong_long(max_size).reject(&:zero?)
  end

  def self.max_polyfill_size(geo_polygon, resolution)
    geo_polygon = geo_json_to_coordinates(geo_polygon) if geo_polygon.is_a?(String)
    maxPolyfillSize(build_polygon(geo_polygon), resolution)
  end

  def self.polyfill(geo_polygon, resolution)
    geo_polygon = geo_json_to_coordinates(geo_polygon) if geo_polygon.is_a?(String)
    max_size = max_polyfill_size(geo_polygon, resolution)
    out = FFI::MemoryPointer.new(H3_INDEX, max_size)
    _polyfill(build_polygon(geo_polygon), resolution, out)
    out.read_array_of_ulong_long(max_size).reject(&:zero?)
  end

  def self.h3_set_to_linked_geo(h3_indexes)
    linked_geo_polygon = Structs::LinkedGeoPolygon.new
    FFI::MemoryPointer.new(H3_INDEX, h3_indexes.size) do |hexagons_ptr|
      hexagons_ptr.write_array_of_ulong_long(h3_indexes)
      h3SetToLinkedGeo(hexagons_ptr, h3_indexes.size, linked_geo_polygon)
    end

    extract_linked_geo_polygon(linked_geo_polygon).first
  end

  def self.extract_linked_geo_polygon(linked_geo_polygon)
    return if linked_geo_polygon.null?

    geo_polygons = [linked_geo_polygon]

    until linked_geo_polygon[:next].null? do
      geo_polygons << linked_geo_polygon[:next]
      linked_geo_polygon = linked_geo_polygon[:next]
    end

    geo_polygons.map(&method(:extract_geo_polygon))
  end

  def self.extract_geo_polygon(geo_polygon)
    extract_linked_geo_loop(geo_polygon[:first]) unless geo_polygon[:first].null?
  end

  def self.extract_linked_geo_loop(linked_geo_loop)
    return if linked_geo_loop.null?

    geo_loops = [linked_geo_loop]

    until linked_geo_loop[:next].null? do
      geo_loops << linked_geo_loop[:next]
      linked_geo_loop = linked_geo_loop[:next]
    end

    geo_loops.map(&method(:extract_geo_loop))
  end

  def self.extract_geo_loop(geo_loop)
    extract_linked_geo_coord(geo_loop[:first]) unless geo_loop[:first].null?
  end

  def self.extract_linked_geo_coord(linked_geo_coord)
    return if linked_geo_coord.null?

    geo_coords = [linked_geo_coord]

    until linked_geo_coord[:next].null? do
      geo_coords << linked_geo_coord[:next]
      linked_geo_coord = linked_geo_coord[:next]
    end

    geo_coords.map(&method(:extract_geo_coord))
  end

  def self.extract_geo_coord(geo_coord)
    [
      rads_to_degs(geo_coord[:vertex][:lat]),
      rads_to_degs(geo_coord[:vertex][:lon])
    ]
  end

  def self.geo_json_to_coordinates(input)
    geom = RGeo::GeoJSON.decode(input)
    coordinates = if geom.respond_to?(:first) # feature collection
                    geom.first.geometry.coordinates
                  elsif geom.respond_to?(:geometry) # feature
                    geom.geometry.coordinates
                  elsif geom.respond_to?(:coordinates) # polygon
                    geom.coordinates
                  else
                    raise "Could not parse given input. Please use a GeoJSON polygon."
                  end
    swap_lat_lon(coordinates)
  end

  # geo-json coordinates use [lon, lat], h3 uses [lat, lon]
  def self.swap_lat_lon(coordinates)
    coordinates.map { |polygon| polygon.map { |x, y| [y, x] } }
  end

  def self.coordinates_to_geo_json(coordinates)
    coordinates = swap_lat_lon(coordinates)
    outer_coords, *inner_coords = coordinates
    factory = RGeo::Cartesian.simple_factory
    exterior = factory.linear_ring(outer_coords.map! { |lon, lat| factory.point(lon, lat) })
    interior_rings = inner_coords.map do |polygon|
      factory.linear_ring(polygon.map { |lon, lat| factory.point(lon, lat) })
    end
    polygon = factory.polygon(exterior, interior_rings)
    RGeo::GeoJSON.encode(polygon).to_json
  end

  def self.build_polygon(input)
    outline, *holes = input
    geo_polygon = Structs::GeoPolygon.new
    geo_polygon[:geofence] = build_geofence(outline)
    len = holes.count
    geo_polygon[:num_holes] = len
    geofences = holes.map(&method(:build_geofence))
    ptr = FFI::MemoryPointer.new(Structs::GeoFence, len)
    fence_structs = geofences.count.times.map do |i|
      Structs::GeoFence.new(ptr + i * Structs::GeoFence.size())
    end
    geofences.each_with_index do |geofence, i|
      fence_structs[i][:num_verts] = geofence[:num_verts]
      fence_structs[i][:verts] = geofence[:verts]
    end
    geo_polygon[:holes] = ptr
    geo_polygon
  end

  def self.build_geofence(input)
    geo_fence = Structs::GeoFence.new
    len = input.count
    geo_fence[:num_verts] = len
    ptr = FFI::MemoryPointer.new(Structs::GeoCoord, len)
    coords = 0.upto(len).map do |i|
      Structs::GeoCoord.new(ptr + i * Structs::GeoCoord.size)
    end
    input.each_with_index do |(lat, lon), i|
      coords[i][:lat] = degs_to_rads(lat)
      coords[i][:lon] = degs_to_rads(lon)
    end
    geo_fence[:verts] = ptr
    geo_fence
  end
end
