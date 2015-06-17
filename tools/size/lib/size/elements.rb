require_relative "../metric/counting_metric"
require "parser/current"

module Size
  class Elements < Metric::CountingMetric
    def initialize(root, options)
      super
      @type = options[:type]
    end

    def metric_name
      @type
    end

    def measure(source_file)
      abstract_syntax_tree = parse(source_file)
      counter = self.class.counters[@type].new
      counter.process(abstract_syntax_tree)
      counter.count
    end

    def parse(source_file)
      source = File.read(source_file)
      Parser::CurrentRuby.parse(source)
    end

    def self.counters
      {
        "modules" => ModuleCounter,
        "classes" => ClassCounter,
        "methods" => MethodCounter,
        "class_methods" => ClassMethodCounter,
        "attributes" => AttributeCounter
      }
    end
  end

  class Counter < Parser::AST::Processor
    attr_reader :count

    def initialize
      @count = 0
    end

    def increment
      @count += 1
    end
  end

  class ModuleCounter < Counter
    def on_module(node)
      super(node)
      increment
    end
  end

  class ClassCounter < Counter
  end

  class MethodCounter < Counter
  end

  class ClassMethodCounter < Counter
  end

  class AttributeCounter < Counter
  end
end
