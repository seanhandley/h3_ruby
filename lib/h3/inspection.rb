module H3
  # Index inspection functions.
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/inspection
  module Inspection
    extend H3::Bindings::Base

    H3_TO_STR_BUF_SIZE = 17
    private_constant :H3_TO_STR_BUF_SIZE

    # @!method resolution(h3_index)
    #
    # Derive the resolution of a given H3 index
    #
    # @param [Integer] h3_index A valid H3 index
    #
    # @example Derive the resolution of a H3 index
    #   H3.resolution(617700440100569087)
    #   9
    #
    # @return [Integer] Resolution of H3 index
    attach_function :resolution, :h3GetResolution, %i[h3_index], Resolution

    # @deprecated Please use {#resolution} instead.
    def h3_resolution(h3_index)
      resolution(h3_index)
    end
    deprecate :h3_resolution, :resolution, 2020, 1

    # @!method base_cell(h3_index)
    #
    # Derives the base cell number of the given H3 index
    #
    # @param [Integer] h3_index A valid H3 index
    #
    # @example Derive the base cell number of a H3 index
    #   H3.base_cell(617700440100569087)
    #   20
    #
    # @return [Integer] Base cell number
    attach_function :base_cell, :h3GetBaseCell, %i[h3_index], :int

    # @deprecated Please use {#base_cell} instead.
    def h3_base_cell(h3_index)
      base_cell(h3_index)
    end
    deprecate :h3_base_cell, :base_cell, 2020, 1

    # @!method from_string(h3_string)
    #
    # Derives the H3 index for a given hexadecimal string representation.
    #
    # @param [String] h3_string A H3 index in hexadecimal form.
    #
    # @example Derive the H3 index from the given hexadecimal form.
    #   H3.from_string("8928308280fffff")
    #   617700169958293503
    #
    # @return [Integer] H3 index
    attach_function :from_string, :stringToH3, %i[string], :h3_index

    # @deprecated Please use {#from_string} instead.
    def string_to_h3(string)
      from_string(string)
    end
    deprecate :string_to_h3, :from_string, 2020, 1

    # @!method pentagon?(h3_index)
    #
    # Determine whether the given H3 index is a pentagon.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Check if H3 index is a pentagon
    #   H3.pentagon?(585961082523222015)
    #   true
    #
    # @return [Boolean] True if the H3 index is a pentagon.
    attach_function :pentagon, :h3IsPentagon, %i[h3_index], :bool
    alias_method :pentagon?, :pentagon
    undef_method :pentagon

    # @deprecated Please use {#pentagon?} instead.
    def h3_pentagon?(h3_index)
      pentagon?(h3_index)
    end
    deprecate :h3_pentagon?, :pentagon?, 2020, 1

    # @!method class_3_resolution?(h3_index)
    #
    # Determine whether the given H3 index has a resolution with
    # Class III orientation.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Check if H3 index has a class III resolution.
    #   H3.class_3_resolution?(599686042433355775)
    #   true
    #
    # @return [Boolean] True if the H3 index has a class III resolution.
    attach_function :class_3_resolution, :h3IsResClassIII, %i[h3_index], :bool
    alias_method :class_3_resolution?, :class_3_resolution
    undef_method :class_3_resolution

    # @deprecated Please use {#class_3_resolution?} instead.
    def h3_res_class_3?(h3_index)
      class_3_resolution?(h3_index)
    end
    deprecate :h3_res_class_3?, :class_3_resolution?, 2020, 1

    # @!method valid?(h3_index)
    #
    # Determine whether the given H3 index is valid.
    #
    # @param [Integer] h3_index A H3 index.
    #
    # @example Check if H3 index is valid
    #   H3.valid?(599686042433355775)
    #   true
    #
    # @return [Boolean] True if the H3 index is valid.
    attach_function :valid, :h3IsValid, %i[h3_index], :bool
    alias_method :valid?, :valid
    undef_method :valid

    # @deprecated Please use {#valid?} instead.
    def h3_valid?(h3_index)
      valid?(h3_index)
    end
    deprecate :h3_valid?, :valid?, 2020, 1

    # Derives the hexadecimal string representation for a given H3 index.
    #
    # @param [Integer] h3_index A valid H3 index.
    #
    # @example Derive the given hexadecimal form for the H3 index
    #   H3.to_string(617700169958293503)
    #   "89283470dcbffff"
    #
    # @return [String] H3 index in hexadecimal form.
    def to_string(h3_index)
      h3_str = FFI::MemoryPointer.new(:char, H3_TO_STR_BUF_SIZE)
      Bindings::Private.h3_to_string(h3_index, h3_str, H3_TO_STR_BUF_SIZE)
      h3_str.read_string
    end

    # @deprecated Please use {#to_string} instead.
    def h3_to_string(h3_index)
      to_string(h3_index)
    end
    deprecate :h3_to_string, :to_strings, 2020, 1

    # @!method max_face_count(h3_index)
    #
    # Returns the maximum number of icosahedron faces the given H3 index may intersect.
    #
    # @param [Integer] h3_index A H3 index.
    #
    # @example Check maximum faces
    #   H3.max_face_count(585961082523222015)
    #   5
    #
    # @return [Integer] Maximum possible number of faces
    attach_function :max_face_count, :maxFaceCount, %i[h3_index], :int

    # Find all icosahedron faces intersected by a given H3 index.
    #
    # @param [Integer] h3_index A H3 index.
    #
    # @example Find icosahedron faces for given index
    #   H3.faces(585961082523222015)
    #   [1, 2, 6, 7, 11]
    #
    # @return [Array<Integer>] Faces. Faces are represented as integers from 0-19, inclusive.
    def faces(h3_index)
      max_faces = max_face_count(h3_index)
      out = FFI::MemoryPointer.new(:int, max_faces)
      Bindings::Private.h3_faces(h3_index, out)
      # The C function returns a sparse array whose holes are represented by -1.
      out.read_array_of_int(max_faces).reject(&:negative?).sort
    end

    # @deprecated Please use {#faces} instead.
    def h3_faces(h3_index)
      faces(h3_index)
    end
    deprecate :h3_faces, :faces, 2020, 1
  end
end
