# H3 Ruby

Ruby bindings for Uber's [H3 library](https://uber.github.io/h3/).

TODO: Add more wrapper functions.

## Getting Started

* Follow the h3 instructions for installing the C lib at https://github.com/uber/h3. You will need to build from source.
* Run `rake compile`.

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
