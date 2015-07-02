require_relative "../subjects/class"

module Locator
  class ClassLocator
    def find_subjects_in(project)
      project.files.flat_map do |source_file|
        processor = FindClassProcessor.new(source_file)
        processor.process(source_file.ast)
        processor.classes
      end
    end

    class FindClassProcessor < Parser::AST::Processor
      attr_reader :classes

      def initialize(source_file)
        @source_file = source_file
        @classes = []
      end

      def on_class(node)
        super(node)
        @classes << Subjects::Class.new(@source_file, node)
      end
    end
  end
end
