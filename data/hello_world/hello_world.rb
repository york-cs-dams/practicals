# A (slightly long-winded) first Ruby program
class HelloWorld
  attr_reader :name

  def initialize(name = "world")
    @name = name
  end

  def run
    "Hello, #{name}!"
  end
end

HelloWorld.new.run  # instantiate the class and run the instance
