require_relative "../metric/counting_metric"

module Size
  class LOC < Metric::CountingMetric
    def initialize(root, options)
      super
      @include_blanks = options[:blanks]
      @include_comments = options[:comments]
    end

    def metric_name
      name = "LOC"
      name += ", ignoring blanks" unless @include_blanks
      name += ", ignoring comments" unless @include_comments
      name
    end

    # Start by editing this method
    def measure(source_file)
      lines = File.readlines(source_file)
      lines.size
    end
  end
end
