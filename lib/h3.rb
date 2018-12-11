require "h3/h3"
require "h3/version"

module H3
  def self.bearing_between(from, to, options={})
    _bearing_between(from, to, options[:method] == :spherical)
  end
end
