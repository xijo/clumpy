require 'spec_helper'

class Hit
  def primary_key
    :foo
  end

  def class_name
    'Foo'
  end

  def stored(key)
    key
  end
end

describe Clumpy::Extensions::SunspotHit do
  let(:hit)          { Hit.new }
  let(:extended_hit) { Hit.new.extend(Clumpy::Extensions::SunspotHit) }

  it "adds #latitude method" do
    hit.should_not      respond_to :latitude
    extended_hit.should respond_to :latitude
    extended_hit.latitude.should eq :lat
  end

  it "adds #longitude method" do
    hit.should_not      respond_to :longitude
    extended_hit.should respond_to :longitude
    extended_hit.longitude.should eq :lng
  end

  it "overrides as_json to return minimal representation" do
    extended_hit.as_json.should eq({ id: :foo, type: 'Foo' })
  end
end
