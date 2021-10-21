require_relative "lib/h3/version"

Gem::Specification.new do |spec|
  spec.name     = "h3"
  spec.version  = H3::VERSION
  spec.licenses = ["MIT"]
  spec.summary  = "C Bindings for Uber's H3 library"
  spec.homepage = "https://github.com/StuartApp/h3_ruby"
  spec.authors  = ["Lachlan Laycock", "Sean Handley"]
  spec.email    = "l.laycock@stuart.com"

  spec.required_ruby_version = ">= 2.5"
  spec.files = `git ls-files --recurse-submodules`.split("\n")

  spec.add_runtime_dependency "ffi", "~> 1.9"
  spec.add_runtime_dependency "rgeo-geojson", "~> 2.1"
  spec.add_runtime_dependency "zeitwerk", "~> 2.1"

  # spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "yard", "~> 0.9"

  spec.extensions << "ext/h3/extconf.rb"
end
