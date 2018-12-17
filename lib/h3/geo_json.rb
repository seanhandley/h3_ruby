module H3
  module GeoJSON
    def geo_json_to_coordinates(input)
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

    def coordinates_to_geo_json(coordinates)
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

    private

    # geo-json coordinates use [lon, lat], h3 uses [lat, lon]
    def swap_lat_lon(coordinates)
      coordinates.map { |polygon| polygon.map { |x, y| [y, x] } }
    end
  end
end
