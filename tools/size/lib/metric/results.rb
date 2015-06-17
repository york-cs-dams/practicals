module Metric
  class Results
    def initialize(source_files, measurements)
      @results = Hash[source_files.zip(measurements)]
    end

    def total
      @results.values.reduce(:+)
    end

    def mean
      total.to_f / @results.values.size
    end

    def to_s
      @results.map { |source_file, measurement| "  * #{source_file} - #{measurement}" }.join("\n")
    end
  end
end
