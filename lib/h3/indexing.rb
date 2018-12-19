module H3
  module Indexing
    def geo_to_h3(coords, resolution)
      raise TypeError unless coords.is_a?(Array)
      raise ArgumentError unless coords.count == 2
      raise RangeError if coords.any? { |d| d > 1000000 }

      lat, lon = coords
      coords = Bindings::Structs::GeoCoord.new
      coords[:lat] = degs_to_rads(lat)
      coords[:lon] = degs_to_rads(lon)
      Bindings::Private.geo_to_h3(coords, resolution)
    end

    def h3_to_geo(h3_index)
      coords = Bindings::Structs::GeoCoord.new
      Bindings::Private.h3_to_geo(h3_index, coords)
      [rads_to_degs(coords[:lat]), rads_to_degs(coords[:lon])]
    end

    def h3_to_geo_boundary(h3_index)
      geo_boundary = Bindings::Structs::GeoBoundary.new
      Bindings::Private.h3_to_geo_boundary(h3_index, geo_boundary)
      geo_boundary[:verts].take(geo_boundary[:num_verts] * 2).map do |d|
        rads_to_degs(d)
      end.each_slice(2).to_a
    end
  end
end
