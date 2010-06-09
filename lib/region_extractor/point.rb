class RegionExtractor
  include Proj4
  class Point
    attr_accessor :x, :y
    
    def initialize(x,y)
      @x = x
      @y = y
    end
    
    def self.tranform_point(point, origin_projection, destination_projection)
      output = origin_projection.transform(destination_projection, point)
      Point.new(output.x * Proj4::RAD_TO_DEG, output.y * Proj4::RAD_TO_DEG, destination_projection)
    end
  end
end