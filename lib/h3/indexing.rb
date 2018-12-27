module H3
  # Indexing functions.
  #
  # Coordinates are returned in degrees, in the form
  #
  #   [latitude, longitude]
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/indexing
  module Indexing
    include Bindings::Structs
    # Derive H3 index for the given set of coordinates.
    #
    # @param [Array<Integer>] coords A coordinate pair.
    # @param [Integer] resolution The desired resolution of the H3 index.
    #
    # @example Derive the H3 index for the given coordinates.
    #   H3.geo_to_h3([52.24630137198303, -1.7358398437499998], 9)
    #   617439284584775679
    #
    # @raise [ArgumentError] If coordinates are invalid.
    #
    # @return [Integer] H3 index.
    def geo_to_h3(coords, resolution)
      raise ArgumentError unless coords.is_a?(Array) && coords.count == 2

      lat, lon = coords

      if lat > 90 || lat < -90 || lon > 180 || lon < -180
        raise(ArgumentError, "Invalid coordinates")
      end

      coords = GeoCoord.new
      coords[:lat] = degs_to_rads(lat)
      coords[:lon] = degs_to_rads(lon)
      Bindings::Private.geo_to_h3(coords, resolution)
    end

    # Derive coordinates for a given H3 index.
    #
    # The coordinates map to the centre of the hexagon at the given index.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Derive the central coordinates for the given H3 index.
    #   H3.h3_to_geo(617439284584775679)
    #   [52.245519061399506, -1.7363137757391423]
    #
    # @return [Array<Integer>] A coordinate pair.
    def h3_to_geo(h3_index)
      coords = GeoCoord.new
      Bindings::Private.h3_to_geo(h3_index, coords)
      [rads_to_degs(coords[:lat]), rads_to_degs(coords[:lon])]
    end

    # Derive the geographical boundary as coordinates for a given H3 index.
    #
    # This will be a set of 6 coordinate pairs matching the vertexes of the
    # hexagon represented by the given H3 index.
    #
    # If the H3 index is a pentagon, there will be only 5 coordinate pairs returned.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Derive the geographical boundary for the given H3 index.
    #   H3.h3_to_geo_boundary(617439284584775679)
    #   [
    #     [52.247260929171055, -1.736809158397472], [52.24625850761068, -1.7389279144996015],
    #     [52.244516619273476, -1.7384324668792375], [52.243777169245725, -1.7358184256304658],
    #     [52.24477956752282, -1.7336997597088104], [52.246521439109415, -1.7341950448552204]
    #   ]
    #
    # @return [Array<Array<Integer>>] An array of six coordinate pairs.
    def h3_to_geo_boundary(h3_index)
      geo_boundary = GeoBoundary.new
      Bindings::Private.h3_to_geo_boundary(h3_index, geo_boundary)
      geo_boundary[:verts].take(geo_boundary[:num_verts] * 2).map do |d|
        rads_to_degs(d)
      end.each_slice(2).to_a
    end
  end
end
