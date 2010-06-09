class RegionExtractor
  class Region
    attr_accessor :points, :zone
    def initialize(options = {})
      @points = options[:points]
      @zone   = options[:zone]
      @projection = Proj4::Projection.new( :proj => 'utm', :datum => "NAD83", :zone => @zone)
    end
    
    def coordinates(output_projection = Proj4::Projection.new( :proj => 'latlong', :datum => 'WGS84' ))
      if output_projection
        points = @points.map{|p| Point.tranform_point(p, @projection, output_projection) }
      else
        points = @points
      end
      
      points.map{|p|"#{p.x},#{p.y},0.000000"}.join("\n")
    end
  end
end