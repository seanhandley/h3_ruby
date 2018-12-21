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
    attach_function :edge_length_km, :edgeLengthKm, %i[int], :double

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
    attach_function :edge_length_m, :edgeLengthM, %i[int], :double

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
    attach_function :hex_area_km2, :hexAreaKm2, %i[int], :double

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
    attach_function :hex_area_m2, :hexAreaM2, %i[int], :double

    # @!method num_hexagons(resolution)
    #
    # Number of unique H3 indexes at the given resolution.
    #
    # @param [Integer] resolution Resolution.
    #
    # @example Find number of hexagons at resolution 6
    #   H3.num_hexagons(6)
    #   14117882
    #
    # @return [Integer] Number of unique hexagons
    attach_function :num_hexagons, :numHexagons, %i[int], :ulong_long

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
  end
end
