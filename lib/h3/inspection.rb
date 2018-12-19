module H3
  module Inspection
    extend H3::BindingBase

    H3_TO_STR_BUF_SIZE = 32

    attach_function :h3_resolution, :h3GetResolution, [ :h3_index ], :int
    attach_function :h3_base_cell, :h3GetBaseCell, [ :h3_index ], :int
    attach_function :string_to_h3, :stringToH3, [ :string ], :h3_index
    attach_function :h3_pentagon, :h3IsPentagon, [ :h3_index ], :bool
    attach_function :h3_res_class_3, :h3IsResClassIII, [ :h3_index ], :bool
    attach_function :h3_valid, :h3IsValid, [ :h3_index ], :bool

    def h3_to_string(h3_index)
      h3_str = FFI::MemoryPointer.new(:char, H3_TO_STR_BUF_SIZE)
      Bindings::Private.h3_to_string(h3_index, h3_str, H3_TO_STR_BUF_SIZE)
      h3_str.read_string 
    end
  end
end
