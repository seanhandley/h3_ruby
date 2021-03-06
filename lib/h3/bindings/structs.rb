module H3
  module Bindings
    # FFI Structs.
    #
    # These match the structs defined in H3's header file and are required
    # to correctly interact with the library's functions.
    module Structs
      extend FFI::Library

      class GeoCoord < FFI::Struct
        layout :lat, :double,
               :lon, :double
      end

      class GeoBoundary < FFI::Struct
        layout :num_verts, :int,
               :verts, [GeoCoord, 10] # array of GeoCoord structs (must be fixed length)
      end

      class GeoFence < FFI::Struct
        layout :num_verts, :int,
               :verts, :pointer # array of GeoCoord structs
      end

      class GeoPolygon < FFI::Struct
        layout :geofence, GeoFence,
               :num_holes, :int,
               :holes, :pointer # array of GeoFence structs
      end

      class GeoMultiPolygon < FFI::Struct
        layout :num_polygons, :int,
               :polygons, :pointer # array of GeoPolygon structs
      end

      class LinkedGeoCoord < FFI::Struct
        layout :vertex, GeoCoord,
               :next, LinkedGeoCoord.ptr
      end

      class LinkedGeoLoop < FFI::Struct
        layout :first, LinkedGeoCoord.ptr,
               :last, LinkedGeoCoord.ptr,
               :next, LinkedGeoLoop.ptr
      end

      class LinkedGeoPolygon < FFI::Struct
        layout :first, LinkedGeoLoop.ptr,
               :last, LinkedGeoLoop.ptr,
               :next, LinkedGeoPolygon.ptr
      end

      class CoordIJ < FFI::Struct
        layout :i, :int,
               :j, :int
      end
    end
  end
end
