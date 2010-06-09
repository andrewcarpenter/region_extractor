require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RegionExtractor" do
  context "parsing text" do
    context "with no regions present" do
      before(:each) do
        @texts = [
          "",
          "The brown cow.",
          "10/15/1982",
          "Portland, OR 97266; telephone 503-231-6179; facsimile 503-231-6195",
          "<p>Optimal Oregon chub habitat provides 1 square meter (11 square feet) of aquatic surface area per adult, at depths between 0.5 m (1.6 ft) to 2 m (6.6 ft) (Scheerer 2008b).</p>"
        ]
      end
      
      it "returns no regions" do
        @texts.each do |text|
          RegionExtractor.new(text).regions.should == []
        end
      end
      
      it "does not modify the text" do
        @texts.each do |text|
          RegionExtractor.new(text).resulting_text.should == text
        end
      end
    end
    
    context "with one simple region" do
      before(:each) do
        @extractor = RegionExtractor.new("Land bounded by the following UTM Zone 10, NAD83 coordinates (E,N): 557923, 4838857; 557919, 4838854; 557919, 4838854;")
      end
      
      it "finds the correct number of regions" do
        @extractor.regions.size.should == 1
      end
      
      it "the region has the correct number of points" do
        @extractor.regions.first.points.size.should == 3
      end
      
      it "should determine the correct zone" do
        @extractor.regions.first.zone.should == "10"
      end
      
    end
    
    context "with more complex regions" do
      before(:each) do
        @extractor = RegionExtractor.new("<p>Unit 1A consists of boundary points with the following coordinates in UTM Zone 4, with the units in meters, using North American Datum of 1983 (Nad83):</p>
      <p>(A) 451377, 2420941; 451318, 2421296; 451365, 2421383; 451432, 2421109; 451596, 2421040; 451959, 2421072.</p><p>(ii) Follow the approximate coordinates: 457583, 2422071; 457631, 2422040; 457702, 2421952; 457543, 2421778; 457490, 2421812; 457400, 2421778; 457352, 2421693; 457380, 2421601.</p>")
      end
      
      it "finds the correct number of regions" do
        @extractor.regions.size.should == 2
      end
      
      it "the regions have the correct number of points" do
        @extractor.regions[0].points.size.should == 6
        @extractor.regions[1].points.size.should == 8
      end
      
      it "should determine the correct zone" do
        @extractor.regions[0].zone.should == "4"
      end
    end
    
    context "with a block" do
      it "puts a replacement in for each region" do
        extractor = RegionExtractor.new("UTM Zone 10 557923, 4838857; 557919, 4838854; 557919, 4838854. Then 457631, 2421540; 457678, 2421675; 457766, 2421821; 457637, 2421453.") do |str, region, i|
          "#{str}[i=#{i}; points=#{region.points.size}]"
        end
        extractor.resulting_text.should == "UTM Zone 10 557923, 4838857; 557919, 4838854; 557919, 4838854[i=0; points=3]. Then 457631, 2421540; 457678, 2421675; 457766, 2421821; 457637, 2421453[i=1; points=4]."
      end
    end
  end
end

# (ii) Starting on the coastline at approximately coordinates of: 458997, 2422152; follow: 458345, 2422341; 458686, 2422405; 458786, 2422373;458934, 2422253; 459001, 2422151; 458997, 2422152; 457589, 2420990; 457575, 2420975; 457511, 2420984; 457631, 2421127; 457738, 2421168; 457900, 2421206; 458023, 2421343; 458023, 2421417; 457895, 2421435; 457803, 2421394; 457686, 2421405; 457637, 2421453; 457631, 2421540; 457678, 2421675; 457766, 2421821; 457908, 2421944; 458069, 2421867; 458216, 2421849; 458244, 2421886; 458253, 2421996; 458235, 2422079; 458299, 2422272; 458345, 2422341; 457589, 2420990; to approximately: 457590, 2420991 (coastline); follow coastline to the approximate coordinates of: 458494, 2421794; then follow: 458494, 2421795; 458495, 2421795; 458502, 2421802, 458492, 2421904; 458483, 2421987; 458566, 2422060; 458559, 2422190; 458630, 2422263; 458718, 2422262; 458805, 2422159; 458777, 2422115; 458686, 2422119; 458658, 2422060; 458667, 2421987; 458702, 2421920; to the coastline, approximately at: 458702, 2421919; follow coastline to beginning point: 458997, 2422152.