require "ffi"

module H3
  module Structs
    extend FFI::Library

    class GeoCoord < FFI::Struct
      layout :lat, :double,
             :lon, :double
    end
  end
end
