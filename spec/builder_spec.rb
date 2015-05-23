require 'spec_helper'

describe Clumpy::Builder do
  let(:point1) { OpenStruct.new(latitude: 15,   longitude: 20) }
  let(:point2) { OpenStruct.new(latitude: 15.5, longitude: 20.5) }
  let(:point3) { OpenStruct.new(latitude: 50,   longitude: 50) }

  let(:points)  { [point1, point2, point3] }
  let(:builder) { Clumpy::Builder.new(points) }

  it "takes points and options" do
    builder = Clumpy::Builder.new(points, { foo: :bar })
    expect(builder.points).to eq points
    expect(builder.options).to eq({ foo: :bar })
  end

  it "initializes the distance_modifier is none was given" do
    builder = Clumpy::Builder.new([])
    expect(builder.instance_variable_get(:@distance_modifier)).not_to be_nil
  end

  it 'takes the given distance modifier' do
    builder = Clumpy::Builder.new([], distance_modifier: 12)
    expect(builder.instance_variable_get(:@distance_modifier)).to eq 12
  end

  context "#cluster" do
    it "creates clusters from points" do
      clusters = builder.cluster
      expect(clusters.size).to eq 2
      expect(clusters.first.points).to eq [point1, point2]
      expect(clusters.last.points).to eq [point3]
    end
  end

  it "passes the values threshold through to the cluster" do
    builder = Clumpy::Builder.new([point1], values_threshold: 100, include_values: true)
    expect(builder.cluster_options).to eq({ values_threshold: 100, include_values: true, side_length: 33.128196875 })
    clusters = builder.cluster
    expect(clusters.first.instance_variable_get(:@options)).to eq builder.cluster_options
  end

  context "#add_to_cluster" do
    it "creates a new cluster if there is no matching" do
      expect(builder.clusters).to be_empty
      builder.add_to_cluster(point1)
      expect(builder.clusters.size).to eq 1
    end

    it "will not create a cluster if the given value is not a true point" do
      expect(builder.clusters).to be_empty
      builder.add_to_cluster(:foo)
      expect(builder.clusters).to be_empty
    end

    it "appends markers to a existing cluster if they match" do
      builder.clusters << Clumpy::Cluster.new(point1, builder.cluster_options)
      expect(builder.clusters.size).to eq 1
      expect(builder.clusters.first.points.size).to eq 1
      builder.add_to_cluster(point2)
      expect(builder.clusters.size).to eq 1
      expect(builder.clusters.first.points.size).to eq 2
    end
  end

  it "calculates the latitude distance" do
    expect(builder.latitude_distance).to eq Clumpy::Builder::MAX_LATITUDE_DISTANCE
    builder.options = { nelat: -30, swlat: 40 }
    expect(builder.latitude_distance).to eq 70
    builder.options = { nelat: -30, swlat: -35 }
    expect(builder.latitude_distance).to eq 5
    builder.options = { nelat: 20, swlat: 35 }
    expect(builder.latitude_distance).to eq 15
  end
end
