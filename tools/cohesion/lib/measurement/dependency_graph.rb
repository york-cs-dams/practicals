require 'rgl/adjacency'
require 'rgl/connected_components'

module Measurement
  class DependencyGraph
    def add(dependent, dependee)
      graph.add_edge(DependencyNode.new(dependent), DependencyNode.new(dependee))
      self
    end

    def add_all(dependent, dependees)
      dependees.each { |dependee|  add(dependent, dependee) }
      self
    end

    def number_of_components
      components.size
    end

    def components_summary
      components.map(&:sort).map(&:to_s).join(", ")
    end

    private

    def components
      graph.to_enum(:each_connected_component).to_a
    end

    def graph
      @graph ||= RGL::AdjacencyGraph.new
    end

    class DependencyNode
      include Comparable

      attr_reader :name

      def initialize(name)
        @name = name
      end

      def foo
        name.to_s.sub(/^@/, '')
      end

      def <=>(other)
        foo <=> other.foo
      end

      def eql?(other)
        name.eql?(other.name)
      end

      def hash
        name.hash
      end

      def inspect
        name.inspect
      end

      def to_s
        name.to_s
      end
    end

  end
end
