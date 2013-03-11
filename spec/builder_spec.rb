require 'spec_helper'

describe Clumpy::Builder do
  let(:point1) { OpenStruct.new(lat: 15,   lng: 20) }
  let(:point2) { OpenStruct.new(lat: 15.5, lng: 20.5) }
  let(:point3) { OpenStruct.new(lat: 50,   lng: 50) }

  let(:points)  { [point1, point2, point3] }
  let(:builder) { Clumpy::Builder.new(points) }

  it "takes points and options" do
    builder = Clumpy::Builder.new(points, { foo: :bar })
    builder.points.should eq points
    builder.options.should eq({ foo: :bar })
  end

  context "#cluster" do
    it "creates clusters from points" do
      clusters = builder.cluster
      clusters.size.should eq 2
      clusters.first.points.should eq [point1, point2]
      clusters.last.points.should eq [point3]
    end
  end

  context "#add_to_cluster" do
    it "creates a new cluster if there is no matching" do
      builder.clusters.should be_empty
      builder.add_to_cluster(point1)
      builder.clusters.size.should eq 1
    end

    it "appends markers to a existing cluster if they match" do
      builder.clusters << Clumpy::Cluster.new(point1, builder.cluster_distance)
      builder.clusters.size.should eq 1
      builder.clusters.first.points.size.should eq 1
      builder.add_to_cluster(point2)
      builder.clusters.size.should eq 1
      builder.clusters.first.points.size.should eq 2
    end
  end

  context "#find_parent_cluster" do
    it "returns the surrounding cluster if there is one" do

    end
  end

  it "calculates the latitude distance" do
    builder.latitude_distance.should eq Clumpy::Builder::MAX_LATITUDE_DISTANCE
    builder.options = { nelat: -30, swlat: 40 }
    builder.latitude_distance.should eq 70
    builder.options = { nelat: -30, swlat: -35 }
    builder.latitude_distance.should eq 5
    builder.options = { nelat: 20, swlat: 35 }
    builder.latitude_distance.should eq 15
  end
end
