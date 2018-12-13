require "ffi"

module H3
  module Structs
    extend FFI::Library

    class GeoCoord < FFI::Struct
      layout :lat, :double,
             :lon, :double
    end

    class GeoBoundary < FFI::Struct
      layout :num_verts, :int,
             :verts, [:double, 20]
    end
  end
end
