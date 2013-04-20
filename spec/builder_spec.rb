require 'spec_helper'

describe Clumpy::Builder do
  let(:point1) { OpenStruct.new(latitude: 15,   longitude: 20) }
  let(:point2) { OpenStruct.new(latitude: 15.5, longitude: 20.5) }
  let(:point3) { OpenStruct.new(latitude: 50,   longitude: 50) }

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

  it "passes the values threshold through to the cluster" do
    builder = Clumpy::Builder.new([point1], values_threshold: 100, include_values: true)
    builder.cluster_options.should eq({ values_threshold: 100, include_values: true })
    clusters = builder.cluster
    clusters.first.instance_variable_get(:@options).should eq builder.cluster_options
  end

  context "#add_to_cluster" do
    it "creates a new cluster if there is no matching" do
      builder.clusters.should be_empty
      builder.add_to_cluster(point1)
      builder.clusters.size.should eq 1
    end

    it "will not create a cluster if the given value is not a true point" do
      builder.clusters.should be_empty
      builder.add_to_cluster(:foo)
      builder.clusters.should be_empty
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
