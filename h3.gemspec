require_relative "lib/h3/version"

Gem::Specification.new do |spec|
  spec.name     = "h3"
  spec.version  = H3::VERSION
  spec.licenses = ["MIT"]
  spec.summary  = "C Bindings for Uber's H3 library"
  spec.homepage = "https://github.com/StuartApp/h3_ruby"
  spec.authors  = ["Lachlan Laycock", "Sean Handley"]
  spec.email    = "l.laycock@stuart.com"

  spec.required_ruby_version = "> 2.3"
  spec.files = `git ls-files`.split("\n")

  spec.add_runtime_dependency "ffi", "~> 1.9"
  spec.add_runtime_dependency "rgeo-geojson", "~> 2.1"

  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.8"
end
