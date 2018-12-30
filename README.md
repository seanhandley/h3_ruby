# H3 Ruby

![h3](https://user-images.githubusercontent.com/98526/50283275-48177300-044d-11e9-8337-eba8d3cc88a2.png)

[![Build Status](https://travis-ci.org/StuartApp/h3_ruby.svg?branch=master)](https://travis-ci.org/seanhandley/h3_ruby) [![Maintainability](https://api.codeclimate.com/v1/badges/c55e1f67421eba8af8d0/maintainability)](https://codeclimate.com/repos/5c18b7f49bc79a02a4000d81/maintainability) [![Coverage Status](https://coveralls.io/repos/github/StuartApp/h3_ruby/badge.svg?branch=master)](https://coveralls.io/github/StuartApp/h3_ruby?branch=master) [![Gem Version](https://badge.fury.io/rb/h3.svg)](https://badge.fury.io/rb/h3)

Ruby-to-C bindings for Uber's [H3 library](https://uber.github.io/h3/).

Please consult [the H3 documentation](https://uber.github.io/h3/#/documentation/overview/introduction) for a full explanation of terminology and concepts.

## Supported H3 Versions

The semantic versioning of this gem matches the versioning of the H3 C library. E.g. version `3.2.x` of this gem is targeted for version `3.2.y` of H3 C lib where `x` and `y` are independent patch levels.

## Naming Conventions

We have changed camel-case method names to snake-case, as per the Ruby convention.

In addition, some methods using the `get` verb have been renamed i.e. `getH3UnidirectionalEdgesFromHexagon` becomes `h3_unidirectional_edges_from_hexagon`.

We have also suffixed predicate methods with a question mark, as per the Ruby convention, and removed `is` from the name i.e. `h3IsPentagon` becomes `h3_pentagon?`

## Getting Started

This gem uses FFI to link directly into the H3 library (written in C).

Before using the gem, you will need to install the C lib at https://github.com/uber/h3.

Install the build dependencies as instructed here: https://github.com/uber/h3#install-build-time-dependencies

Do *not* follow the Compilation Steps. Instead, use the following:

    git clone git@github.com:uber/h3.git h3_build
    cd h3_build
    cmake . -DBUILD_SHARED_LIBS=true
    make
    sudo make install

The key difference is the `BUILD_SHARED_LIBS` option.

## Installing

You can install the gem directly using

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
H3.geo_to_h3([53.959130, -1.079230], 8).to_s(16)
=> "8819429a9dfffff"
H3.h3_valid?("8819429a9dfffff".to_i(16))
=> true
H3.h3_pentagon?("8819429a9dfffff".to_i(16))
=> false
H3.h3_to_geo_boundary("8819429a9dfffff".to_i(16))
=> [[53.962987505331384, -1.079984346847996], [53.9618315234061, -1.0870313428985856], [53.95744798515881, -1.0882421079017874], [53.95422067486053, -1.082406760751464], [53.955376670617454, -1.0753609232787642], [53.95975996282198, -1.074149274503605]]
```

## Documentation

There is a full reference available here: https://www.rubydoc.info/github/StuartApp/h3_ruby/H3

## Running Specs

    rake

## Contributing

Pull requests and issues are welcome!
