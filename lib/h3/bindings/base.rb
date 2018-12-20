module H3
  module Bindings
    module Base
      def self.extended(base)
        base.extend FFI::Library
        base.ffi_lib ["libh3", "libh3.1"]
        base.typedef :ulong_long, :h3_index
        base.const_set('H3_INDEX', :ulong_long)
      end
    end
  end
end
