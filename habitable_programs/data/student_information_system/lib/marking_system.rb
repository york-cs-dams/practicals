require_relative "york/student_info"

class MarkingSystem
  def add_marks(module_code, year, marks)
    registry = York::StudentInfo.instance
    mod = registry.find_module(module_code, true)
    assessment = registry.create_assessment(mod, year)

    marks.each do |student_number, mark|
      registry.add_mark(assessment, student_number, mark)
    end

    registry.finalise_assessment(assessment)
  end

  def summarise_marks(module_code, year)
    registry = York::StudentInfo.instance
    mod = registry.find_module(module_code, false)
    return "" if mod.nil?

    marks = mod.assessments.find { |ass| ass.year == year }.marks
    marks.map { |student_number, mark| "#{student_number}: #{mark}" }.join("\n")
  end
end
