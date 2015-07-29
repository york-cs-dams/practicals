require_relative "subject"

module Subjects
  class Module < Subject
    attr_reader :source_file, :ast

    def initialize(source_file, ast)
      @source_file = source_file
      @ast = ast
    end

    def identifier
      ast.children.first
    end

    def to_s
      "#{file_name}##{class_name}"
    end

    def file_name
      source_file.to_s
    end

    def class_name
      names_from_const(identifier).join("::")
    end

    def names_from_const(const)
      prefixes = const.children.first.nil? ? [] : names_from_const(const.children.first)
      prefixes << const.children.last.to_s
    end
  end
end
