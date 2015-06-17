require_relative "results"
require 'pathname'

module Metric
  class CountingMetric
    def initialize(root, options)
      @root = Pathname.new(root)
      @source_files = Dir.glob("#{root}/**/*.rb")
    end

    def run
      results = Results.new(names, measurements)

      puts "Counting #{metric_name}:"
      puts results
      puts "Total: #{results.total}. Mean: #{results.mean.round(2)}."
    end

    def names
      @source_files.map { |f| Pathname.new(f).relative_path_from(@root).to_s }
    end

    def measurements
      @source_files.map { |f| measure(f) }
    end
  end
end
