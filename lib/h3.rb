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

  # Internal bindings related modules and classes.
  #
  # These are intended to be used by the library's public methods
  # and not to be used directly by client code.
  module Bindings; end
end
