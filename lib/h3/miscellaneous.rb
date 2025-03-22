module H3
  # Miscellaneous functions.
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/miscellaneous
  module Miscellaneous
    extend H3::Bindings::Base

    # @!method degs_to_rads(degs)
    #
    # Convert a number expressed in degrees to its equivalent in radians.
    #
    # @param [Float] degs Value expressed in degrees.
    #
    # @example Convert degrees value to radians.
    #   H3.degs_to_rads(19.61922082086965)
    #   0.34242
    #
    # @return [Float] Value expressed in radians.
    attach_function :degs_to_rads, :degsToRads, %i[double], :double

    # @!method edge_length_km(resolution)
    #
    # Derive the length of a hexagon edge in kilometres at the given resolution.
    #
    # @param [Integer] resolution Resolution.
    #
    # @example Derive length of edge in kilometres
    #   H3.edge_length_km(3)
    #   59.81085794
    #
    # @return [Float] Length of edge in kilometres
    def edge_length_km(resolution)
      Bindings::Private.safe_call(:double, :edge_length_km, resolution)
    end

    # @!method edge_length_m(resolution)
    #
    # Derive the length of a hexagon edge in metres at the given resolution.
    #
    # @param [Integer] resolution Resolution.
    #
    # @example Derive length of edge in metres
    #   H3.edge_length_m(6)
    #   3229.482772
    #
    # @return [Float] Length of edge in metres
    def edge_length_m(resolution)
      Bindings::Private.safe_call(:double, :edge_length_m, resolution)
    end

    # @!method hex_area_km2(resolution)
    #
    # Average hexagon area in square kilometres at the given resolution.
    #
    # @param [Integer] resolution Resolution.
    #
    # @example Find the square kilometre size at resolution 5
    #   H3.hex_area_km2(5)
    #   252.9033645
    #
    # @return [Float] Average hexagon area in square kilometres.
    attach_function :hex_area_km2, :getHexagonAreaAvgKm2, [Resolution], :double

    # @!method hex_area_m2(resolution)
    #
    # Average hexagon area in square metres at the given resolution.
    #
    # @param [Integer] resolution Resolution.
    #
    # @example Find the square metre size at resolution 10
    #   H3.hex_area_m2(10)
    #   15047.5
    #
    # @return [Float] Average hexagon area in square metres.
    attach_function :hex_area_m2, :getHexagonAreaAvgM2, [Resolution], :double

    # @!method hexagon_count(resolution)
    #
    # Number of unique H3 indexes at the given resolution.
    #
    # @param [Integer] resolution Resolution.
    #
    # @example Find number of hexagons at resolution 6
    #   H3.hexagon_count(6)
    #   14117882
    #
    # @return [Integer] Number of unique hexagons
    def hexagon_count(resolution)
      out = FFI::MemoryPointer.new(:int64)
      H3::Bindings::Private.hexagon_count(resolution, out).tap do |code|
        Bindings::Error::raise_error(code) unless code.zero?
      end
      out.read_int64
    end

    # @!method rads_to_degs(rads)
    #
    # Convert a number expressed in radians to its equivalent in degrees.
    #
    # @param [Float] rads Value expressed in radians.
    #
    # @example Convert radians value to degrees.
    #   H3.rads_to_degs(0.34242)
    #   19.61922082086965
    #
    # @return [Float] Value expressed in degrees.
    attach_function :rads_to_degs, :radsToDegs, %i[double], :double

    # @!method base_cell_count
    #
    # Returns the number of resolution 0 hexagons (base cells).
    #
    # @example Return the number of base cells
    #    H3.base_cell_count
    #    122
    #
    # @return [Integer] The number of resolution 0 hexagons (base cells).
    attach_function :base_cell_count, :res0CellCount, [], :int

    # @!method pentagon_count
    #
    # Number of pentagon H3 indexes per resolution.
    # This is always 12, but provided as a convenience.
    #
    # @example Return the number of pentagons
    #    H3.pentagon_count
    #    12
    #
    # @return [Integer] The number of pentagons per resolution.
    attach_function :pentagon_count, :pentagonCount, [], :int

    # @!method cell_area_rads2
    #
    # Area of a given cell expressed in radians squared
    #
    # @example Return the area of the cell
    #    H3.cell_area_rads2(617700169958293503)
    #    2.6952182709835757e-09
    #
    # @return [Double] Area of cell in rads2
    attach_function :cell_area_rads2, :cellAreaRads2, %i[h3_index], :double

    # @!method cell_area_km2
    #
    # Area of a given cell expressed in km squared
    #
    # @example Return the area of the cell
    #    H3.cell_area_km2(617700169958293503)
    #    0.10939818864648902
    #
    # @return [Double] Area of cell in km2
    attach_function :cell_area_km2, :cellAreaKm2, %i[h3_index], :double

    # @!method cell_area_m2
    #
    # Area of a given cell expressed in metres squared
    #
    # @example Return the area of the cell
    #    H3.cell_area_m2(617700169958293503)
    #    109398.18864648901
    #
    # @return [Double] Area of cell in metres squared
    attach_function :cell_area_m2, :cellAreaM2, %i[h3_index], :double

    # @!method exact_edge_length_rads
    #
    # Exact length of edge in rads
    #
    # @example Return the edge length
    #    H3.exact_edge_length_rads(1266218516299644927)
    #    3.287684056071637e-05
    #
    # @return [Double] Edge length in rads
    attach_function :exact_edge_length_rads, :getDirectedEdgeLengthRads, %i[h3_index], :double

    # @!method exact_edge_length_km
    #
    # Exact length of edge in kilometres
    #
    # @example Return the edge length
    #    H3.exact_edge_length_km(1266218516299644927)
    #    3.287684056071637e-05
    #
    # @return [Double] Edge length in kilometres
    attach_function :exact_edge_length_km, :getDirectedEdgeLengthKm, %i[h3_index], :double

    # @!method exact_edge_length_m
    #
    # Exact length of edge in metres
    #
    # @example Return the edge length
    #    H3.exact_edge_length_m(1266218516299644927)
    #    3.287684056071637e-05
    #
    # @return [Double] Edge length in metres
    attach_function :exact_edge_length_m, :getDirectedEdgeLengthM, %i[h3_index], :double

    # Returns the radians distance between two points.
    #
    # @example Return radians distance.
    #   H3.point_distance_rads([41.3964809, 2.160444], [41.3870609, 2.164917])
    #   0.00017453024784008713
    #
    # @return [Double] Radians distance between two points.
    def point_distance_rads(origin, destination)
      Bindings::Private.point_distance_rads(*build_geocoords(origin, destination))
    end

    # Returns the kilometres distance between two points.
    #
    # @example Return km distance.
    #   H3.point_distance_km([41.3964809, 2.160444], [41.3870609, 2.164917])
    #   1.1119334622766763
    #
    # @return [Double] KM distance between two points.
    def point_distance_km(origin, destination)
      Bindings::Private.point_distance_km(*build_geocoords(origin, destination))
    end

    # Returns the metre distance between two points.
    #
    # @example Return metre distance.
    #   H3.point_distance_m([41.3964809, 2.160444], [41.3870609, 2.164917])
    #   1111.9334622766764
    #
    # @return [Double] Metre distance between two points.
    def point_distance_m(origin, destination)
      Bindings::Private.point_distance_m(*build_geocoords(origin, destination))
    end

    # Returns all resolution 0 hexagons (base cells).
    #
    # @example Return all base cells.
    #   H3.base_cells
    #   [576495936675512319, 576531121047601151, ..., 580753245698260991]
    #
    # @return [Array<Integer>] All resolution 0 hexagons (base cells).
    def base_cells
      out = H3Indexes.of_size(base_cell_count)
      Bindings::Private.res_0_indexes(out).tap do |code|
        Bindings::Error::raise_error(code) unless code.zero?
      end
      out.read
    end

    # Returns all pentagon indexes at the given resolution.
    #
    # @example Return all pentagons at resolution 4.
    #   H3.pentagons(4)
    #   [594615896891195391, 594967740612083711, ..., 598591730937233407]
    #
    # @return [Array<Integer>] All pentagon indexes at the given resolution.
    def pentagons(resolution)
      out = H3Indexes.of_size(pentagon_count)
      Bindings::Private.get_pentagon_indexes(resolution, out).tap do |code|
        Bindings::Error::raise_error(code) unless code.zero?
      end
      out.read
    end

    private

    def build_geocoords(origin, destination)
      [origin, destination].inject([]) do |acc, coords|
        validate_coordinate(coords)

        geo_coord = GeoCoord.new
        lat, lon = coords
        geo_coord[:lat] = degs_to_rads(lat)
        geo_coord[:lon] = degs_to_rads(lon)
        acc << geo_coord
      end
    end

    def validate_coordinate(coords)
      raise ArgumentError unless coords.is_a?(Array) && coords.count == 2

      lat, lon = coords

      if lat > 90 || lat < -90 || lon > 180 || lon < -180
        raise(ArgumentError, "Invalid coordinates")
      end
    end
  end
end
