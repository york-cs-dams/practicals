module York
  class StudentInfo
    def self.instance
      @instance ||= new
    end

    def self.reset
      @instance = nil
    end

    def initialize
      @modules = []
    end
    private :initialize

    def find_module(module_code, create_if_not_found)
      mod = @modules.find { |m| m.code == module_code }
      mod = create_module(module_code) if create_if_not_found && mod.nil?
      mod
    end

    def create_module(module_code)
      mod = Module.new(module_code)
      @modules << mod
      mod
    end
    private :create_module

    def create_assessment(mod, year)
      mod.find_or_create_assessment(year)
    end

    def add_mark(assessment, student_number, mark)
      assessment.marks[student_number] = mark
    end

    def finalise_assessment(assessment)
      assessment.marks.freeze
    end
  end

  class Module
    attr_reader :code

    def initialize(code)
      @code = code
    end

    def assessments
      @assessments ||= []
    end

    def find_or_create_assessment(year)
      assessment = assessments.find { |a| a.year == year }
      if assessment.nil?
        assessment = Assessment.new(year)
        assessments << assessment
      end
      assessment
    end
  end

  class Assessment
    attr_reader :year

    def initialize(year)
      @year = year
    end

    def marks
      @marks ||= {}
    end
  end
end
