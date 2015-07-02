require_relative "counter"

module Measurement
  class ConditionCounter < Counter

    private

    def leaves(node)
      if node.respond_to?(:children) && !node.children.empty?
        node.children.flat_map { |child| leaves(child) }
      else
        [node]
      end
    end
  end
end
