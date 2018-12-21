require "ffi"
require "rgeo/geo_json"

require "h3/bindings"
require "h3/geo_json"
require "h3/hierarchy"
require "h3/indexing"
require "h3/inspection"
require "h3/miscellaneous"
require "h3/regions"
require "h3/traversal"
require "h3/unidirectional_edges"

# The main H3 namespace.
#
# All public methods for the library are defined here.
#
# @see https://uber.github.io/h3/#/documentation/overview/introduction
module H3
  class << self
    include GeoJSON
    include Hierarchy
    include Miscellaneous
    include Indexing
    include Inspection
    include Regions
    include Traversal
    include UnidirectionalEdges
  end

  PREDICATES = %i(h3_indexes_neighbors h3_pentagon h3_res_class_3
                  h3_unidirectional_edge_valid h3_valid).freeze
  PREDICATES.each do |predicate|
    singleton_class.send(:alias_method, "#{predicate}?".to_sym, predicate)
  end
end
