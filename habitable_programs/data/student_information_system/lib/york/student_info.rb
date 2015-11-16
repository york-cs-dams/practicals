module York
  # A fake implementation of a student information system.
  #
  # You should assume that any code under the York:: namespace is maintained by another team, and
  # that you cannot change it.
  class StudentInfo
    # Get a reference to the (only) instance of the information system. (StudentInfo is a singleton).
    def self.instance
      @instance ||= new
    end

    # Clear all of the modules, assessments and marks in the information system.
    def self.reset
      @instance = nil
    end

    # Finds a module by its code. If no module exists with that code, return a new module.
    # Returns an instance of York::Module.
    def find_module(module_code, create_if_not_found)
      mod = @modules.find { |m| m.code == module_code }
      mod = create_module(module_code) if create_if_not_found && mod.nil?
      mod
    end

    # Finds a module's assessment by its year. If no assessment exists for that module in that year,
    # a new assesment is created.
    # Returns an instance of York::Assessment
    def create_assessment(mod, year)
      mod.find_or_create_assessment(year)
    end

    # Adds a mark to an assessment for the given student (identified by their student number)
    def add_mark(assessment, student_number, mark)
      assessment.marks[student_number] = mark
    end

    # Confirms that all marks for an assessment have been entered, and prevents any further changes.
    def finalise_assessment(assessment)
      assessment.marks.freeze
    end

    private

    def initialize
      @modules = []
    end

    def create_module(module_code)
      mod = Module.new(module_code)
      @modules << mod
      mod
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
