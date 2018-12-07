require "h3_ruby/h3"
require "h3_ruby/version"

module H3Ruby
  def self.bearing_between(from, to, options={})
    _bearing_between(from, to, options[:method] == :spherical)
  end
end
