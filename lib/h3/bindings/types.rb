module H3
  module Bindings
    module Types
      class Resolution
        extend FFI::DataConverter
        native_type FFI::Type::INT

        RES_RANGE = 0..15

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
    end
  end
end
