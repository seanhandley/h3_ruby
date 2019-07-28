# H3 Ruby

![h3](https://user-images.githubusercontent.com/98526/50283275-48177300-044d-11e9-8337-eba8d3cc88a2.png)

[![Build Status](https://travis-ci.org/StuartApp/h3_ruby.svg?branch=master)](https://travis-ci.org/seanhandley/h3_ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/74a47e7fa516588ab545/maintainability)](https://codeclimate.com/repos/5ca38395a86379029800281f/maintainability) [![Coverage Status](https://coveralls.io/repos/github/StuartApp/h3_ruby/badge.svg?branch=master)](https://coveralls.io/github/StuartApp/h3_ruby?branch=master) [![Gem Version](https://badge.fury.io/rb/h3.svg)](https://badge.fury.io/rb/h3)

Ruby-to-C bindings for Uber's [H3 library](https://uber.github.io/h3/).

Please consult [the H3 documentation](https://uber.github.io/h3/#/documentation/overview/introduction) for a full explanation of terminology and concepts.

## Supported H3 Versions

The semantic versioning of this gem matches the versioning of the H3 C library. E.g. version `3.5.x` of this gem is targeted for version `3.5.y` of H3 C lib where `x` and `y` are independent patch levels.

## Naming Conventions

We have changed camel-case method names to snake-case, as per the Ruby convention.

In addition, some methods using the `get` verb have been renamed i.e. `getH3UnidirectionalEdgesFromHexagon` becomes `unidirectional_edges_from_hexagon`.

We have also suffixed predicate methods with a question mark, as per the Ruby convention, and removed `h3Is` from the name i.e. `h3IsPentagon` becomes `pentagon?`

## Getting Started

This gem uses FFI to link directly into the H3 library (written in C).

The H3 library is packaged with the gem and is built as a native extension. H3 is not installed system-wide, so it will not interfere with any other versions you may have installed previously.

Before installing the gem, please install the build dependencies for your system as instructed here: https://github.com/uber/h3#install-build-time-dependencies

## Installing

You can install the gem directly from RubyGems.org using

    gem install h3

or add it to your Gemfile

```ruby
# Gemfile
gem "h3", "~> 3.2"
```

## Usage

Require the gem in your code

```ruby
require "h3"
```

Call H3 functions via the `H3` namespace

```ruby
H3.from_geo_coordinates([53.959130, -1.079230], 8).to_s(16)
=> "8819429a9dfffff"
H3.valid?("8819429a9dfffff".to_i(16))
=> true
H3.pentagon?("8819429a9dfffff".to_i(16))
=> false
H3.to_boundary("8819429a9dfffff".to_i(16))
=> [[53.962987505331384, -1.079984346847996], [53.9618315234061, -1.0870313428985856], [53.95744798515881, -1.0882421079017874], [53.95422067486053, -1.082406760751464], [53.955376670617454, -1.0753609232787642], [53.95975996282198, -1.074149274503605]]
```

## Documentation

Please read [the Gem Documentation](https://www.rubydoc.info/github/StuartApp/h3_ruby/H3) for a full reference of available methods.

## Development

The development environment requires the H3 library to be compiled from source before tests can be executed.

This is done automatically by the test suite. However, Rake tasks are provided to handle building H3 in a more fine-grained manner.

### Building H3

    rake build

You can remove the compiled H3 library with `rake clean`, or rebuild it with `rake rebuild`.

### Running Tests

The test suite exercises all the H3 functions.

    rake spec

Be aware that errors may be encountered if you have a locally cached H3 binary that's older than the version targeted. Try `rake rebuild` and re-run `rake spec` if this occurs.

## Contributing

Pull requests and issues are welcome! Please read [the Contributing Guide](./CONTRIBUTING.md) for more info.
