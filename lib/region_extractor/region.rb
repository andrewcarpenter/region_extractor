class RegionExtractor
  class Region
    attr_accessor :points, :zone
    def initialize(options = {})
      @points = options[:points]
      @zone   = options[:zone]
      @projection = Proj4::Projection.new( :proj => 'utm', :datum => "NAD83", :zone => @zone)
    end
    
    def transformed_points(output_projection = Proj4::Projection.new( :proj => 'latlong', :datum => 'WGS84' ))
      @points.map{|p| Point.tranform_point(p, @projection, output_projection) }
    end
    
    def coordinates(output_projection = Proj4::Projection.new( :proj => 'latlong', :datum => 'WGS84' ))
      transformed_points(output_projection).map{|p|"#{p.x},#{p.y},0.000000"}.join("\n")
    end
  end
end