require 'rubygems'
require 'proj4'

require "region_extractor/region"
require "region_extractor/point"

class RegionExtractor
  attr_accessor :regions, :resulting_text
  
  def initialize(text, &region_transformer)
    @text = text || ''
    @regions = []
    @resulting_text = text
    @region_transformer = region_transformer
    extract!
  end
  
  private
  
  def extract!
    @resulting_text = @text.gsub(/(?:excluding land bound by )?(?:\d{6,7}\s*,\s*\d{6,7};\s*){2,}\d{6,7}\s*,\s*\d{6,7}/) do |region_string|
      match = @text.match(/UTM [z|Z]one (\d+)/)
      zone = match ? match[1] : ''
      
      points = region_string.sub(/^excluding land bound by /,'').split(/\s*;\s*/).map do |c|
        x , y = c.split(/\s*,\s*/)
        Point.new(x.to_i,y.to_i)
      end
      
      region = Region.new(:points => points, :zone => zone)
      if region_string =~ /^excluding/
        prior_region = @regions.last
        prior_region.add_hole(region)
        
        region_string # don't modify the document
      else
        @regions << region

        if @region_transformer
          @region_transformer.call(region_string, region, @regions.size-1)
        else
          nil
        end
      end
    end
  end
end

# extractor = RegionExtractor.new("507093, 4879404; 507095, 4879401") do |region, i|
#   "<div id=\"map_#{i}\"></div>"
# 
# end
# 
# extractor.regions
# extractor.resulting_text