require_relative "../../../common/lib/subjects/project"
require_relative "clone"

module Detection
  class CloneDetector
    def initialize(root)
      @project = Subjects::Project.new(root)
    end

    def run
      @project.files.each do |file|
        clones = clones_for(file)
        print_clones(file, clones)
      end
    end

    def clones_for(file)
      @project
       .files_other_than(file)
       .flat_map { |other_file| clones_between(file.source, other_file.source) }
       .sort
       .reverse
    end

    def print_clones(file, clones)
      puts "#{file}"
      puts "-"*file.to_s.size
      clones.each { |c| puts c }
      puts ""
    end

    def clones_between(source, other_source)
      longest_common_fragment = source.longest_common_fragment_with(other_source)

      if longest_common_fragment.empty?
        []
      else
        [Clone.new(source, other_source, longest_common_fragment)]
      end
    end
  end
end
