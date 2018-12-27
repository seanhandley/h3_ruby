module H3
  module Bindings
    # Custom FFI Types
    module Types
      # A H3 resolution value.
      #
      # Integer, but must be between 0 and 15 inclusive.
      class Resolution
        extend FFI::DataConverter
        native_type FFI::Type::INT

        RES_RANGE = 0..15
        private_constant :RES_RANGE

        class << self
          def to_native(value, _context)
            failure unless value.is_a?(Integer) && RES_RANGE.cover?(value)
            value
          end

          private

          def failure
            raise ArgumentError, 
                  "resolution must be between #{RES_RANGE.first} and #{RES_RANGE.last}"
          end
        end
      end

      class H3SetIn
        extend FFI::DataConverter
        native_type FFI::Type::POINTER

        def self.to_native(h3_set_in, _context)
          h3_set_in.ptr
        end

        attr_reader :ptr, :size

        def initialize(set)
          @size = set.size   
          ptr.write_array_of_ulong_long(set)
        end

        def ptr
          @ptr ||= FFI::MemoryPointer.new(:ulong_long, size)
        end
      end

      class H3SetOut < H3SetIn
        native_type FFI::Type::POINTER

        def initialize(size)
          @size = size
        end

        def read
          @read ||= ptr.read_array_of_ulong_long(size).reject(&:zero?)
        end
      end
    end
  end
end
