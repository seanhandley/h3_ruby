$: << File.expand_path("lib", __dir__)
require "h3_ruby/version"

Gem::Specification.new do |spec|
  spec.name     = "h3"
  spec.version  = H3Ruby::VERSION
  spec.licenses = ["Nonstandard"] # Avoids a warning when building the gem.
  spec.summary  = "C Bindings for Uber's H3 library"
  spec.homepage = "https://github.com/StuartApp/h3_ruby"
  spec.authors  = ["Lachlan Laycock", "Sean Handley"]
  spec.email    = "l.laycock@stuart.com"

  spec.extensions = %w(ext/h3/extconf.rb)
  spec.require_paths = %w(lib)
  spec.files = %w(
    ext/h3/extconf.rb
    ext/h3/h3.c
    lib/h3_ruby.rb
    lib/h3_ruby/version.rb
  )
end
