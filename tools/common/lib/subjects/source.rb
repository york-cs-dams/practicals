module Subjects
  # Represents a piece of source code, which (probably) came from a file
  class Source
    # The entire source represented as an array of lines (strings)
    attr_reader :lines

    # The SourceFile that contains this source code. This attribute is nil
    # when the source code is not stored on (local) disk
    attr_reader :file

    def initialize(lines, file = nil)
      @lines, @file = lines, file
    end

    # Returns a fragment that is common to `self` and `other_source` and that is
    # longer than any other common fragment. Note that when `self` and `other_source`
    # have no common fragments, a zero-length fragment (`[]`) is returned.
    def longest_common_fragment_with(other_source)
      []
    end

    # Returns a fragments that appear in both `self` and in `other_source`
    # of the specified size.
    def common_fragment_with(other_source, fragment_size)
      []
    end

    # Returns all fragments of a given size, where a fragment is an array containing
    # a subset of lines in the original source. It might help to note that:
    #  * fragments(lines.size).to_a == [lines]
    #  * fragments(1).to_a == lines.map { |l| [l] }
    def fragments(size)
      lines.each_cons(size)
    end
  end
end
