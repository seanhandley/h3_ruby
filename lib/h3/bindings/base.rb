module H3
  module Bindings
    # Base for FFI Bindings.
    #
    # When extended, this module sets up FFI to use the H3 C library.
    module Base
      def self.extended(base)
        lib_path = File.expand_path(__dir__ + "/../../../ext/h3/src/lib")
        base.extend FFI::Library
        base.include Structs
        base.include Types
        base.ffi_lib ["#{lib_path}/libh3.dylib", "#{lib_path}/libh3.so"]
        base.typedef :ulong_long, :h3_index
        base.typedef :int, :size
        base.typedef :int, :k_distance
        base.typedef :pointer, :h3_set
        base.typedef :pointer, :output_buffer
        base.const_set("H3_INDEX", :ulong_long)
      end
    end
  end
end
