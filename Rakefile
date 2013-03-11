require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -rubygems -I lib -r clumpy.rb'
end

desc 'Run a simple benchmarking'
task :benchmark do
  require 'benchmark'
  require 'ostruct'
  require 'clumpy'

  number = 20_000
  points = []
  max_lat_range = -85..85.05115
  max_lng_range = -180..180
  number.times { points << OpenStruct.new(lat: rand(max_lat_range), lng: rand(max_lng_range)) }

  Benchmark.bm do |x|
    x.report('low precision') do
      clusters = Clumpy::Builder.new(points).cluster
    end

    x.report('high precision') do
      clusters = Clumpy::Builder.new(points, precision: :high).cluster
    end
  end
end
