require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/file_locator"

module Measurement
  class FileMeasurer < Measurer
    def locator
      Locator::FileLocator.new
    end

    def measurements_for(file)
      {
        lines_of_code: count_lines_of_code(file),
        number_of_modules: count_modules(file),
        number_of_classes: count_classes(file)
      }
    end

    def count_lines_of_code(file)
      "?"
    end

    def count_modules(file)
      "?"
    end

    def count_classes(file)
      "?"
    end
  end
end
