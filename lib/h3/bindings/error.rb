module H3
  module Bindings
    module Error
      class FailedError < StandardError ; end
      class DomainError < StandardError ; end
      class LatLngDomainError < StandardError ; end
      class ResolutionDomainError < StandardError ; end
      class CellInvalidError < StandardError ; end
      class DirectedEdgeInvalidError < StandardError ; end
      class UndirectedEdgeInvalidError < StandardError ; end
      class VertexInvalidError < StandardError ; end
      class PentagonDistortionError < StandardError ; end
      class DuplicateInputError < StandardError ; end
      class NotNeighborsError < StandardError ; end
      class ResolutionMismatchError < StandardError ; end
      class MemoryAllocationError < StandardError ; end
      class MemoryBoundsError < StandardError ; end

      def self.raise_error(code)
        case code
          when 1  then raise FailedError
          when 2  then raise DomainError
          when 3  then raise LatLngDomainError
          when 4  then raise ResolutionDomainError
          when 5  then raise CellInvalidError
          when 6  then raise DirectedEdgeInvalidError
          when 7  then raise UndirectedEdgeInvalidError
          when 8  then raise VertexInvalidError
          when 9  then raise PentagonDistortionError
          when 10 then raise DuplicateInputError
          when 11 then raise NotNeighborsError
          when 12 then raise ResolutionMismatchError
          when 13 then raise MemoryAllocationError
          when 14 then raise MemoryBoundsError
        end
      end
    end
  end
end
