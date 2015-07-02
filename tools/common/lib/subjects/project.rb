require_relative "source_file"
require "pathname"

module Subjects
  class Project
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def files
      Dir.glob("#{root}/**/*.rb").map { |f| SourceFile.new(f, self) }
    end

    def relative_path_to(absolute_path)
      Pathname.new(absolute_path).relative_path_from(Pathname.new(root)).to_s
    end
  end
end
