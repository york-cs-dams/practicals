require_relative "measurer"
require_relative "../locator/method_locator"

module Measurement
  class MethodMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      {
        lines_of_code: count_lines_of_code(method),
        number_of_parameters: count_parameters(method)
      }
    end

    def count_lines_of_code(method)
      "?"
    end

    def count_parameters(method)
      "?"
    end
  end
end
