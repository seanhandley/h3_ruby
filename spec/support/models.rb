class Location
  attr_reader :lat, :lon

  def initialize(lat, lon)
    @lat = lat
    @lon = lon
  end

  def to_coordinates
    [@lat, @lon]
  end

  def to_radians
    to_coordinates.map do |degrees|
      degrees*Math::PI/180.0
    end
  end
end
