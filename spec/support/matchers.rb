require "rspec/expectations"

RSpec::Matchers.define :approx do |expected|
  delta = 1e-11

  match do |actual|
    case actual
    when Array
      actual.zip(expected).each do |a, e|
        expect(a).to approx(e)
      end
    else
      expect(actual).to be_within(delta).of(expected)
    end
  end
end
