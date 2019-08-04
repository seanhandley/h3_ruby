require "ffi"
require "rgeo/geo_json"
require "zeitwerk"

Zeitwerk::Loader.for_gem.setup

# The main H3 namespace.
#
# All public methods for the library are defined here.
#
# @see https://uber.github.io/h3/#/documentation/overview/introduction
module H3
  extend GeoJson
  extend Hierarchy
  extend Miscellaneous
  extend Indexing
  extend Inspection
  extend Regions
  extend Traversal
  extend UnidirectionalEdges

  PREDICATES = %i[h3_indexes_neighbors h3_pentagon h3_res_class_3
                  h3_unidirectional_edge_valid h3_valid].freeze
  private_constant :PREDICATES

  class << self
    # FFI's attach_function doesn't allow method names ending with a
    # question mark. This works around the issue by dynamically
    # renaming those methods afterwards.
    PREDICATES.each do |predicate|
      alias_method "#{predicate}?", predicate
      undef_method predicate
    end
  end

  # Internal bindings related modules and classes.
  #
  # These are intended to be used by the library's public methods
  # and not to be used directly by client code.
  module Bindings; end
end
