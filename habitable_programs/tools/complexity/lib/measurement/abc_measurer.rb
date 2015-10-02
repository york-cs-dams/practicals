require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"
require_relative "assignment_counter"
require_relative "branch_counter"
require_relative "condition_counter"

module Measurement
  class ABCMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      a = count_with(AssignmentCounter, method)
      b = count_with(BranchCounter, method)
      c = count_with(ConditionCounter, method)

      {
        assignments: a,
        branches: b,
        conditions: c,
        abc: magnitude(a, b, c)
      }
    end

    def count_with(counter_type, method)
      counter = counter_type.new
      counter.process(method.ast)
      counter.count
    end

    def magnitude(a, b, c)
      # x**y means "x raised to the power of y"
      Math.sqrt(a**2 + b**2 + c**2).round(2)
    end
  end
end
