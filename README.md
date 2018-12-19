# H3 Ruby

[![Build Status](https://travis-ci.org/StuartApp/h3_ruby.svg?branch=master)](https://travis-ci.org/seanhandley/h3_ruby)

Ruby bindings for Uber's [H3 library](https://uber.github.io/h3/).

TODO: Add more wrapper functions.

## Getting Started

You need to install the C lib at https://github.com/uber/h3.

Install the build dependencies as instructed here: https://github.com/uber/h3#install-build-time-dependencies

Do *not* follow the Compilation Steps. Instead, use the following:

    git clone git@github.com:uber/h3.git
    cd h3
    cmake . -DBUILD_SHARED_LIBS=true
    make
    sudo make install

## Installing

    gem install h3

or

    # Gemfile
    gem "h3", "~> 0.0.1pre"

## Running Specs

    bin/rspec spec

## Usage

```ruby
require "h3"
H3.geo_to_h3([53.959130, -1.079230], 8).to_s(16)
# => "8819429a9dfffff"
```

## GeoJSON

Note that methods returning GeoJSON contain coordinates in the form `[lon, lat]`, whereas H3 coordinates use `[lat, lon]`.
