module Size
  class LOC
    def initialize(root, options)
      @source_files = Dir.glob("#{root}/**/*.rb")
      @include_blanks = options[:blanks]
      @include_comments = options[:comments]
    end

    def run
      puts "Measuring LOC:"
      @source_files.each do |source_file|
        measurement = measure(source_file)
        puts "  * #{source_file} - #{measurement}"
      end
    end

    private

    def measure(source_file)
      lines = File.readlines(source_file)
      lines.size
    end
  end
end
