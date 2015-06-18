require_relative "subject"
require "parser/current"

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

    def to_s
      project.relative_path_to(path)
    end

    private

    def contents
      File.read(path)
    end
  end
end
