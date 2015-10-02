module Subjects
  class Subject
    def source
      ast.loc.expression.source
    end

    def ast
      fail "Must be implemented by subclasses"
    end
  end
end
