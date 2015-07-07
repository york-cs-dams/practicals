module Subjects
  class Source
    attr_reader :lines, :file

    def initialize(lines, file = nil)
      @lines, @file = lines, file
    end

    def longest_common_fragment_with(other_source)
      []
    end

    def common_fragment_with(other_source, fragment_size)
      []
    end

    def fragments(size)
      lines.each_cons(size)
    end
  end
end
