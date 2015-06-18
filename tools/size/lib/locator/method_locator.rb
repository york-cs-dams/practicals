require_relative "../subjects/method"

module Locator
  class MethodLocator
    def find_subjects_in(project)
      project.files.flat_map do |source_file|
        processor = FindMethodProcessor.new(source_file)
        processor.process(source_file.ast)
        processor.methods
      end
    end

    class FindMethodProcessor < Parser::AST::Processor
      attr_reader :methods

      def initialize(source_file)
        @source_file = source_file
        @methods = []
      end

      def on_def(node)
        super(node)
        @methods << Subjects::Method.new(@source_file, node)
      end
    end
  end
end
