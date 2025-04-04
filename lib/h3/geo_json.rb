require 'json'

module H3
  # GeoJSON helper methods.
  #
  # This module allows conversions between GeoJSON polygon data and a nested set of coordinates.
  #
  # It should be noted that H3 describes coordinates as number pairs in the form
  #
  #   [latitude, longitude]
  #
  # whereas the GeoJSON standard uses
  #
  #   [longitude, latitude]
  #
  # Both use degrees.
  #
  # == Coordinates Array
  #
  # We use a nested array to hold coordinates describing a geographical region.
  #
  # The first element in the array is an external geofence boundary, composed of an array of
  # coordinates as 2-element arrays of the form [latitude, longitude].
  #
  # Any further elements in the array are further geofence arrays of coordinates which describe
  # holes that may be present in the polygon.
  #
  # Specific examples are shown in the individual method details.
  #
  # @see http://geojson.io geojson.io - A tool to see GeoJSON data rendered on a world map.
  # @see https://tools.ietf.org/html/rfc7946 The GeoJSON RFC standard.
  module GeoJson
    # Convert a GeoJSON document to a nested array of coordinates.
    #
    # @param [String] input The GeoJSON document. This can be a feature collection, feature,
    #   or polygon. If a feature collection is provided, the first feature is used.
    #
    # @example Convert a GeoJSON document of Banbury to a set of nested coordinates.
    #   document = "{\"type\":\"Polygon\",\"coordinates\":[
    #     [
    #       [-1.7358398437499998,52.24630137198303], [-1.8923950195312498,52.05249047600099],
    #       [-1.56829833984375,51.891749018068246], [-1.27716064453125,51.91208502557545],
    #       [-1.19476318359375,52.032218104145294], [-1.24420166015625,52.19413974159753],
    #       [-1.5902709960937498,52.24125614966341], [-1.7358398437499998,52.24630137198303]
    #     ],
    #     [
    #       [-1.58203125,52.12590076522272], [-1.476287841796875,52.12590076522272],
    #       [-1.46392822265625,52.075285904832334], [-1.58203125,52.06937709602395],
    #       [-1.58203125,52.12590076522272]
    #     ],
    #     [
    #       [-1.4556884765625,52.01531743663362], [-1.483154296875,51.97642166216334],
    #       [-1.3677978515625,51.96626938051444], [-1.3568115234375,52.0102459910103],
    #       [-1.4556884765625,52.01531743663362]
    #     ]
    #   ]}"
    #   H3.geo_json_to_coordinates(document)
    #   [
    #     [
    #       [52.24630137198303, -1.7358398437499998], [52.05249047600099, -1.8923950195312498],
    #       [51.891749018068246, -1.56829833984375], [51.91208502557545, -1.27716064453125],
    #       [52.032218104145294, -1.19476318359375], [52.19413974159753, -1.24420166015625],
    #       [52.24125614966341, -1.5902709960937498], [52.24630137198303, -1.7358398437499998]
    #     ],
    #     [
    #       [52.12590076522272, -1.58203125], [52.12590076522272, -1.476287841796875],
    #       [52.075285904832334, -1.46392822265625], [52.06937709602395, -1.58203125],
    #       [52.12590076522272, -1.58203125]
    #     ],
    #     [
    #       [52.01531743663362, -1.4556884765625], [51.97642166216334, -1.483154296875],
    #       [51.96626938051444, -1.3677978515625], [52.0102459910103, -1.3568115234375],
    #       [52.01531743663362, -1.4556884765625]
    #     ]
    #   ]
    #
    # @raise [ArgumentError] Failed to parse the GeoJSON document.
    #
    # @return [Array<Array<Array>>] Nested array of coordinates.
    def geo_json_to_coordinates(input)
      geom = RGeo::GeoJSON.decode(input)
      coordinates = fetch_coordinates(geom)
      swap_lat_lon(coordinates) || failed_to_parse!
    rescue JSON::ParserError
      failed_to_parse!
    end

    # Convert a nested array of coordinates to a GeoJSON document
    #
    # @param [Array<Array<Array>>] coordinates Nested array of coordinates.
    #
    # @example Convert a set of nested coordinates of Banbury to a GeoJSON document.
    #   coordinates = [
    #     [
    #       [52.24630137198303, -1.7358398437499998], [52.05249047600099, -1.8923950195312498],
    #       [51.891749018068246, -1.56829833984375], [51.91208502557545, -1.27716064453125],
    #       [52.032218104145294, -1.19476318359375], [52.19413974159753, -1.24420166015625],
    #       [52.24125614966341, -1.5902709960937498], [52.24630137198303, -1.7358398437499998]
    #     ],
    #     [
    #       [52.12590076522272, -1.58203125], [52.12590076522272, -1.476287841796875],
    #       [52.075285904832334, -1.46392822265625], [52.06937709602395, -1.58203125],
    #       [52.12590076522272, -1.58203125]
    #     ],
    #     [
    #       [52.01531743663362, -1.4556884765625], [51.97642166216334, -1.483154296875],
    #       [51.96626938051444, -1.3677978515625], [52.0102459910103, -1.3568115234375],
    #       [52.01531743663362, -1.4556884765625]
    #     ]
    #   ]
    #   H3.coordinates_to_geo_json(coordinates)
    #   "{\"type\":\"Polygon\",\"coordinates\":[
    #     [
    #       [-1.7358398437499998,52.24630137198303], [-1.8923950195312498,52.05249047600099],
    #       [-1.56829833984375,51.891749018068246], [-1.27716064453125,51.91208502557545],
    #       [-1.19476318359375,52.032218104145294], [-1.24420166015625,52.19413974159753],
    #       [-1.5902709960937498,52.24125614966341], [-1.7358398437499998,52.24630137198303]
    #     ],
    #     [
    #       [-1.58203125,52.12590076522272], [-1.476287841796875,52.12590076522272],
    #       [-1.46392822265625,52.075285904832334], [-1.58203125,52.06937709602395],
    #       [-1.58203125,52.12590076522272]
    #     ],
    #     [
    #       [-1.4556884765625,52.01531743663362], [-1.483154296875,51.97642166216334],
    #       [-1.3677978515625,51.96626938051444], [-1.3568115234375,52.0102459910103],
    #       [-1.4556884765625,52.01531743663362]
    #     ]
    #   ]}"
    #
    # @raise [ArgumentError] Failed to parse the given coordinates.
    #
    # @return [String] GeoJSON document.
    def coordinates_to_geo_json(coordinates)
      coordinates = swap_lat_lon(coordinates)
      outer_coords, *inner_coords = coordinates
      factory = RGeo::Cartesian.simple_factory
      exterior = factory.linear_ring(outer_coords.map { |lon, lat| factory.point(lon, lat) })
      interior_rings = inner_coords.map do |polygon|
        factory.linear_ring(polygon.map { |lon, lat| factory.point(lon, lat) })
      end
      polygon = factory.polygon(exterior, interior_rings)
      RGeo::GeoJSON.encode(polygon).to_json
    rescue RGeo::Error::InvalidGeometry, NoMethodError
      invalid_coordinates!
    end

    private

    # geo-json coordinates use [lon, lat], h3 uses [lat, lon]
    def swap_lat_lon(coordinates)
      coordinates.map { |polygon| polygon.map { |x, y| [y, x] } }
    end

    def fetch_coordinates(geom)
      if geom.respond_to?(:first) # feature collection
        geom.first.geometry.coordinates
      elsif geom.respond_to?(:geometry) # feature
        geom.geometry.coordinates
      elsif geom.respond_to?(:coordinates) # polygon
        geom.coordinates
      else
        failed_to_parse!
      end
    end

    def failed_to_parse!
      raise ArgumentError, "Could not parse given input. Please use a GeoJSON polygon."
    end

    def invalid_coordinates!
      raise ArgumentError, "Could not parse given coordinates."
    end
  end
end
