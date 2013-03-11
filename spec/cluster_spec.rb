require 'spec_helper'

describe Clumpy::Cluster do
  let(:point)       { OpenStruct.new(lat: 15, lng: 20) }
  let(:other_point) { OpenStruct.new(lat: 40, lng: 40) }
  let(:cluster)     { Clumpy::Cluster.new(point, 10) }

  it "has a nicish to_s representation" do
    cluster.to_s.should include '# points: 1'
  end

  it "has a json represtation as well" do
    cluster.as_json.should have_key :points
    cluster.as_json.should have_key :lat
    cluster.as_json.should have_key :lng
  end

  context "#contains" do
    it "returns true if the given point is within the bounds" do
      cluster.contains?(point).should be_true
    end

    it "returns false for strange values" do
      cluster.contains?(nil).should be_false
      cluster.contains?('').should be_false
      cluster.contains?(42).should be_false
      cluster.contains?([42, 42]).should be_false
    end

    it "returns false for a points that isn't contained" do
      cluster.contains?(other_point).should be_false
    end
  end
end
