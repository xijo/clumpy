require 'spec_helper'

describe Clumpy::ClusterBehavior do
  let(:point)       { OpenStruct.new(latitude: 15, longitude: 20) }
  let(:other_point) { OpenStruct.new(latitude: 40, longitude: 40) }
  let(:cluster)     { Clumpy::Cluster.new(point, side_length: 10) }

  it "has a nicish to_s representation" do
    expect(cluster.to_s).to include '# size: 1'
  end

  it "has a json represtation as well" do
    expect(cluster.as_json).to have_key :size
    expect(cluster.as_json).to have_key :latitude
    expect(cluster.as_json).to have_key :longitude
    expect(cluster.as_json).to have_key :bounds
  end

  context "#reposition" do
    it "calculates new latitude and longitude values" do
      cluster.points << other_point
      cluster.reposition
      expect(cluster.latitude).to eq (15.0+40.0)/2.0
      expect(cluster.longitude).to eq (20.0+40.0)/2.0
    end
  end

  context "#value_list" do
    it "returns an empty array if threshold isn't reached" do
      cluster = Clumpy::Cluster.new(point, values_threshold: 1)
      cluster.points << other_point
      expect(cluster.value_list).to eq []
    end

    it "returns an array of json points if under threshold" do
      cluster = Clumpy::Cluster.new(point, values_threshold: 1)
      expect(cluster.value_list).to eq [point]
    end

    it "returns a list of values if include_values is true" do
      cluster = Clumpy::Cluster.new(point, values_threshold: 0, include_values: true)
      expect(cluster.value_list).to eq [point]
    end

    it "returns a empty list if include_values is false" do
      cluster = Clumpy::Cluster.new(point, values_threshold: 10, include_values: false)
      expect(cluster.value_list).to eq []
    end
  end

  context "#contains" do
    it "returns true if the given point is within the bounds" do
      expect(cluster.contains?(point)).to eq true
    end

    it "returns false for a points that isn't contained" do
      expect(cluster.contains?(other_point)).to eq false
    end
  end
end
