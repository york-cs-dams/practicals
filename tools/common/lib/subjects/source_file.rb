require_relative "subject"
require_relative "source"
require "parser/current"
require "unparser"

module Subjects
  class SourceFile < Subject
    attr_reader :path, :project

    def initialize(path, project)
      @path = path
      @project = project
    end

    def ast
      Parser::CurrentRuby.parse(contents)
    end

    def source
      Source.new(contents.each_line, self)
    end

    def normalized_source
      Source.new(Unparser.unparse(ast).each_line, self)
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
