require_relative "subject"
require_relative "source"
require "parser/current"
require "unparser"

module Subjects
  # Represents a file containing Ruby source code, as a subject
  # that can be measured (e.g., to determine size, or complexity).
  class SourceFile < Subject
    attr_reader :path, :project

    def initialize(path, project)
      @path = path
      @project = project
    end

    # Returns a Ruby Parser AST that represents all of the code
    # in this source file
    def ast
      Parser::CurrentRuby.parse(contents)
    end

    # Returns an instance of Subjects::Source that contains
    # each line of this source file
    def source
      Source.new(contents.each_line, self)
    end

    def normalized_source
      normalized = Unparser.unparse(ast)
      normalized = normalized.each_line.map { |line| line.delete(" \t") }
      Source.new(normalized, self)
    end

    def to_s
      project.relative_path_to(path)
    end

    def eql?(other)
      other.is_a?(SourceFile) && other.to_s == to_s
    end
    alias_method :==, :eql?

    def hash
      to_s.hash
    end

    private

    def contents
      File.read(path)
    end
  end
end
