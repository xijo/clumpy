require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default => :spec

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -rubygems -I lib -r clumpy.rb'
end

desc 'Run a simple benchmarking (cluster 100_000 random points)'
task :benchmark do
  require 'benchmark'
  require 'clumpy'

  number = 100_000
  points = []
  number.times do
    points << OpenStruct.new(
      latitude: rand(Clumpy::Builder::MAX_LATITUDE_DISTANCE),
      longitude: rand(Clumpy::Builder::MAX_LONGITUDE_DISTANCE)
    )
  end

  Benchmark.bm do |x|
    x.report("normal precision") { Clumpy::Builder.new(points).cluster }
    x.report("  high precision") { Clumpy::Builder.new(points, precision: :high).cluster }
  end
end
