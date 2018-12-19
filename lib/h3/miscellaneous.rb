module H3
  module Miscellaneous
    extend H3::BindingBase

    attach_function :degs_to_rads, :degsToRads, [ :double ], :double
    attach_function :edge_length_km, :edgeLengthKm, [ :int ], :double
    attach_function :edge_length_m, :edgeLengthM, [ :int ], :double
    attach_function :hex_area_km2, :hexAreaKm2, [ :int ], :double
    attach_function :hex_area_m2, :hexAreaM2, [ :int ], :double    
    attach_function :max_h3_to_children_size, :maxH3ToChildrenSize, [ :h3_index, :int ], :int
    attach_function :num_hexagons, :numHexagons, [ :int ], :h3_index
    attach_function :rads_to_degs, :radsToDegs, [ :double ], :double
  end
end
