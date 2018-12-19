module H3
  module Regions
    extend H3::BindingBase

    def max_polyfill_size(geo_polygon, resolution)
      geo_polygon = geo_json_to_coordinates(geo_polygon) if geo_polygon.is_a?(String)
      Bindings::Private.max_polyfill_size(build_polygon(geo_polygon), resolution)
    end

    def polyfill(geo_polygon, resolution)
      geo_polygon = geo_json_to_coordinates(geo_polygon) if geo_polygon.is_a?(String)
      max_size = max_polyfill_size(geo_polygon, resolution)
      out = FFI::MemoryPointer.new(H3_INDEX, max_size)
      Bindings::Private.polyfill(build_polygon(geo_polygon), resolution, out)
      out.read_array_of_ulong_long(max_size).reject(&:zero?)
    end

    def h3_set_to_linked_geo(h3_indexes)
      h3_indexes.uniq!
      linked_geo_polygon = Bindings::Structs::LinkedGeoPolygon.new
      FFI::MemoryPointer.new(H3_INDEX, h3_indexes.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(h3_indexes)
        Bindings::Private.h3_set_to_linked_geo(hexagons_ptr, h3_indexes.size, linked_geo_polygon)
      end

      extract_linked_geo_polygon(linked_geo_polygon).first
    end

    private

    def extract_linked_geo_polygon(linked_geo_polygon)
      return if linked_geo_polygon.null?

      geo_polygons = [linked_geo_polygon]

      until linked_geo_polygon[:next].null? do
        geo_polygons << linked_geo_polygon[:next]
        linked_geo_polygon = linked_geo_polygon[:next]
      end

      geo_polygons.map(&method(:extract_geo_polygon))
    end

    def extract_geo_polygon(geo_polygon)
      extract_linked_geo_loop(geo_polygon[:first]) unless geo_polygon[:first].null?
    end

    def extract_linked_geo_loop(linked_geo_loop)
      return if linked_geo_loop.null?

      geo_loops = [linked_geo_loop]

      until linked_geo_loop[:next].null? do
        geo_loops << linked_geo_loop[:next]
        linked_geo_loop = linked_geo_loop[:next]
      end

      geo_loops.map(&method(:extract_geo_loop))
    end

    def extract_geo_loop(geo_loop)
      extract_linked_geo_coord(geo_loop[:first]) unless geo_loop[:first].null?
    end

    def extract_linked_geo_coord(linked_geo_coord)
      return if linked_geo_coord.null?

      geo_coords = [linked_geo_coord]

      until linked_geo_coord[:next].null? do
        geo_coords << linked_geo_coord[:next]
        linked_geo_coord = linked_geo_coord[:next]
      end

      geo_coords.map(&method(:extract_geo_coord))
    end

    def extract_geo_coord(geo_coord)
      [
        rads_to_degs(geo_coord[:vertex][:lat]),
        rads_to_degs(geo_coord[:vertex][:lon])
      ]
    end

    def build_polygon(input)
      outline, *holes = input
      geo_polygon = Bindings::Structs::GeoPolygon.new
      geo_polygon[:geofence] = build_geofence(outline)
      len = holes.count
      geo_polygon[:num_holes] = len
      geofences = holes.map(&method(:build_geofence))
      ptr = FFI::MemoryPointer.new(Bindings::Structs::GeoFence, len)
      fence_structs = geofences.count.times.map do |i|
        Bindings::Structs::GeoFence.new(ptr + i * Bindings::Structs::GeoFence.size())
      end
      geofences.each_with_index do |geofence, i|
        fence_structs[i][:num_verts] = geofence[:num_verts]
        fence_structs[i][:verts] = geofence[:verts]
      end
      geo_polygon[:holes] = ptr
      geo_polygon
    end

    def build_geofence(input)
      geo_fence = Bindings::Structs::GeoFence.new
      len = input.count
      geo_fence[:num_verts] = len
      ptr = FFI::MemoryPointer.new(Bindings::Structs::GeoCoord, len)
      coords = 0.upto(len).map do |i|
        Bindings::Structs::GeoCoord.new(ptr + i * Bindings::Structs::GeoCoord.size)
      end
      input.each_with_index do |(lat, lon), i|
        coords[i][:lat] = degs_to_rads(lat)
        coords[i][:lon] = degs_to_rads(lon)
      end
      geo_fence[:verts] = ptr
      geo_fence
    end
  end
end
