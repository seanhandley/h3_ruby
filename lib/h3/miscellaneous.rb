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
    attach_function :edge_length_km, :edgeLengthKm, [Resolution], :double

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
    attach_function :edge_length_m, :edgeLengthM, [Resolution], :double

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
    attach_function :hex_area_km2, :hexAreaKm2, [Resolution], :double

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
    attach_function :hex_area_m2, :hexAreaM2, [Resolution], :double

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
    attach_function :hexagon_count, :numHexagons, [Resolution], :ulong_long

    # @deprecated Please use {#hexagon_count} instead.
    def num_hexagons(resolution)
      hexagon_count(resolution)
    end
    deprecate :num_hexagons, :hexagon_count, 2020, 1

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
    attach_function :base_cell_count, :res0IndexCount, [], :int

    # @deprecated Please use {#base_cell_count} instead.
    def res_0_index_count
      base_cell_count
    end
    deprecate :res_0_index_count, :base_cell_count, 2020, 1

    # Returns all resolution 0 hexagons (base cells).
    #
    # @example Return all base cells.
    #   H3.base_cells
    #   [576495936675512319, 576531121047601151, ..., 580753245698260991]
    #
    # @return [Array<Integer>] All resolution 0 hexagons (base cells).
    def base_cells
      out = H3Indexes.of_size(res_0_index_count)
      Bindings::Private.res_0_indexes(out)
      out.read
    end

    # @deprecated Please use {#base_cells} instead.
    def res_0_indexes
      base_cells
    end
    deprecate :res_0_indexes, :base_cells, 2020, 1
  end
end
