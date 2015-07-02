require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"

module Measurement
  class MethodMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      {
        assignments: count_assignments(method),
        branches: count_branches(method),
        conditions: count_conditions(method),
        abc: calculate_abc(method)
      }
    end

    def calculate_abc(method)
      a, b, c = count_assignments(method), count_branches(method), count_conditions(method)

      # x**y means "x raised to the power of y"
      Math.sqrt(a**2 + b**2 + c**2).round(2)
    end

    def count_assignments(method)
      0
    end

    def count_branches(method)
      0
    end

    def count_conditions(method)
      0
    end
  end
end
