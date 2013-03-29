require 'spec_helper'

describe Clumpy::ClusterBehavior do
  let(:point)       { OpenStruct.new(latitude: 15, longitude: 20) }
  let(:other_point) { OpenStruct.new(latitude: 40, longitude: 40) }
  let(:cluster)     { Clumpy::Cluster.new(point, 10) }

  it "has a nicish to_s representation" do
    cluster.to_s.should include '# size: 1'
  end

  it "has a json represtation as well" do
    cluster.as_json.should have_key :size
    cluster.as_json.should have_key :latitude
    cluster.as_json.should have_key :longitude
    cluster.as_json.should have_key :bounds
  end

  context "#reposition" do
    it "calculates new latitude and longitude values" do
      cluster.points << other_point
      cluster.reposition
      cluster.latitude.should eq (15.0+40.0)/2.0
      cluster.longitude.should eq (20.0+40.0)/2.0
    end
  end

  context "#contains" do
    it "returns true if the given point is within the bounds" do
      cluster.contains?(point).should be_true
    end

    it "returns false for a points that isn't contained" do
      cluster.contains?(other_point).should be_false
    end
  end
end
