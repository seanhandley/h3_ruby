module H3
  # Index inspection functions.
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/inspection
  module Inspection
    extend H3::Bindings::Base

    H3_TO_STR_BUF_SIZE = 17
    private_constant :H3_TO_STR_BUF_SIZE

    # @!method h3_resolution(h3_index)
    #
    # Derive the resolution of a given H3 index
    #
    # @param [Integer] h3_index A valid H3 index
    #
    # @example Derive the resolution of a H3 index
    #   H3.h3_resolution(617700440100569087)
    #   9
    #
    # @return [Integer] Resolution of H3 index
    attach_function :h3_resolution, :h3GetResolution, %i[h3_index], Resolution

    # @!method h3_base_cell(h3_index)
    #
    # Derives the base cell number of the given H3 index
    #
    # @param [Integer] h3_index A valid H3 index
    #
    # @example Derive the base cell number of a H3 index
    #   H3.h3_base_cell(617700440100569087)
    #   20
    #
    # @return [Integer] Base cell number
    attach_function :h3_base_cell, :h3GetBaseCell, %i[h3_index], :int

    # @!method string_to_h3(h3_string)
    #
    # Derives the H3 index for a given hexadecimal string representation.
    #
    # @param [String] h3_string A H3 index in hexadecimal form.
    #
    # @example Derive the H3 index from the given hexadecimal form.
    #   H3.string_to_h3("8928308280fffff")
    #   617700169958293503
    #
    # @return [Integer] H3 index
    attach_function :string_to_h3, :stringToH3, %i[string], :h3_index

    # @!method h3_pentagon?(h3_index)
    #
    # Determine whether the given H3 index is a pentagon.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Check if H3 index is a pentagon
    #   H3.h3_pentagon?(585961082523222015)
    #   true
    #
    # @return [Boolean] True if the H3 index is a pentagon.
    attach_function :h3_pentagon, :h3IsPentagon, %i[h3_index], :bool

    # @!method h3_res_class_3?(h3_index)
    #
    # Determine whether the given H3 index has a resolution with
    # Class III orientation.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Check if H3 index has a class III resolution.
    #   H3.h3_res_class_3?(599686042433355775)
    #   true
    #
    # @return [Boolean] True if the H3 index has a class III resolution.
    attach_function :h3_res_class_3, :h3IsResClassIII, %i[h3_index], :bool

    # @!method h3_valid?(h3_index)
    #
    # Determine whether the given H3 index is valid.
    #
    # @param [Integer] h3_index A H3 index.
    #
    # @example Check if H3 index is valid
    #   H3.h3_valid?(599686042433355775)
    #   true
    #
    # @return [Boolean] True if the H3 index is valid.
    attach_function :h3_valid, :h3IsValid, %i[h3_index], :bool

    # Derives the hexadecimal string representation for a given H3 index.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Derive the given hexadecimal form for the H3 index
    #   H3.h3_to_string(617700169958293503)
    #   "89283470dcbffff"
    #
    # @return [String] H3 index in hexadecimal form.
    def h3_to_string(h3_index)
      h3_str = FFI::MemoryPointer.new(:char, H3_TO_STR_BUF_SIZE)
      Bindings::Private.h3_to_string(h3_index, h3_str, H3_TO_STR_BUF_SIZE)
      h3_str.read_string
    end
  end
end
