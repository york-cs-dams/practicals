require_relative "../subjects/class"
require_relative "../subjects/module"

module Locator
  class ModuleLocator
    def initialize(include_classes: true)
      @include_classes = include_classes
    end

    def find_subjects_in(project)
      project.files.flat_map do |source_file|
        processor = FindModuleProcessor.new(source_file, @include_classes)
        processor.process(source_file.ast)
        processor.modules
      end
    end

    class FindModuleProcessor < Parser::AST::Processor
      attr_reader :modules

      def initialize(source_file, include_classes = true)
        @source_file = source_file
        @include_classes = include_classes
        @modules = []
      end

      def on_class(node)
        super
        @modules << Subjects::Class.new(@source_file, node) if @include_classes
      end

      def on_module(node)
        super
        @modules << Subjects::Module.new(@source_file, node)
      end
    end
  end
end
