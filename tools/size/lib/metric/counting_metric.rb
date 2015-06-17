require_relative "results"

module Metric
  class CountingMetric
    def initialize(root, options)
      @source_files = Dir.glob("#{root}/**/*.rb")
    end

    def run
      results = Results.new(names, measurements)

      puts "Counting #{metric_name}:"
      puts results
      puts "Total: #{results.total}. Mean: #{results.mean.round(2)}."
    end

    def names
      @source_files
    end

    def measurements
      @source_files.map { |f| measure(f) }
    end
  end
end
