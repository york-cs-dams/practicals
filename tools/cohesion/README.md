# Detecting cohesion

This practical covers:

* Implementing the LCOM4 metric for computing the cohesion of a class
* ...
* Extending the LCOM4 metric to better suit Ruby

## Building the cohesion tool

Your first task is to complete the `cohesion` tool so that it implements the LCOM4 metric, which was discussed in the lectures. The code in this repository contains an executable which can be invoked using `scripts/cohesion lcom4 PROJECT`. Run `scripts/cohesion help` for more information.

The sample projects in the `data` folder can be used to test the cohesion tool. If you run, say, `scripts/cohesion lcom4 hello_world` you'll notice that the `cohesion` tool doesn't do much yet:

| Subject                   | lcom4 | connected_components |
| :------------------------ | :---- | :------------------- |
| hello_world.rb#HelloWorld | 0     |                      |


### Exploring the dependency graph class

Recall that the LCOM4 metric is calculated by counting the number of isolated subgraphs from a class's dependency graph. Because Ruby doesn't provide a built-in graph data structure, a helper class (`DependencyGraph`) has been provided. Start the practical by exploring the `DependencyGraph` class in `irb`:

```ruby
require_relative "tools/cohesion/lib/measurement/dependency_graph"
g = Measurement::DependencyGraph.new

# Suppose that a bake method calls a roll and a cook method:
g.add(:bake, :roll)
g.add(:bake, :cook)
g.number_of_components # => 1
g.components_summary # => "[:bake, :cook, :roll]"

# Also suppose that, within the same class, a worse_rating method calls a rating
# method, which in turn calls a likes method:
g.add(:worse_rating, :rating)
g.add(:rating, :likes)
g.number_of_components # => 2
g.components_summary # => "[:bake, :cook, :roll], "[:likes, :rating, :worse_rating]""

# What happens if you now add a dependency between bake and rating?
```

### Computing cohesion between methods

Our basic approach will be to compute a single LCOM4 score for each class in the system. For each class, we'll need to examine each method to determine which other methods are called. All of this information can be determined from a program's abstract syntax tree, and so a `Parser::AST::Processor` can be used, as has often been the case in other DAMS practicals in this phase of the module. Unlike the other praticals, however, we should use two instances of `Processor` together. The first, `ClassProcessor`, will be responsible for recognising when a `def` statement has been encountered in the AST, invoking the second processor (`MethodProcessor`), and updating the `DependencyGraph` with the results of the second processor. `MethodProcessor` will be responsible for recognising when a `send` statement has been encountered in a specific method's AST, checking to see if the message is being sent to self (i.e., a method defined on the current class is being invoked), and returning a set of all of the messages sent to self. For example, when applied to the following method, `MethodProcessor` would return the following array of messages: `[:roll, :cook]` and `ClassProcessor` would associate the array with `:bake` in the DependencyGraph. (Note that the message `top!` is sent to `@toppings` and not to self).

```ruby
def bake
  base = roll(Dough.new)
  @toppings.top!(base)
  cook(base)
end
```

An implementation of a LCOM4 Measurer that follows this architecture has been provided (see `lib/measurement/lcom4_measurer.rb`). You will need to complete the implementations of `ClassProcessor` and `MethodProcessor`.

Apply the completed tool to the sample projects using `scripts/cohesion lcom4`. The expected results are:

| Subject                                               | lcom4 | connected_components                                                            |
| :---------------------------------------------------- | :---- | :------------------------------------------------------------------------------ |
| adamantium/adamantium/class_methods.rb#ClassMethods   | 1     | [:freezer, :new]                                                                |
| adamantium/adamantium/class_methods.rb#Adamantium     | 0     |                                                                                 |
| adamantium/adamantium/freezer.rb#Flat                 | 0     |                                                                                 |
| adamantium/adamantium/freezer.rb#Deep                 | 0     |                                                                                 |
| adamantium/adamantium/freezer.rb#UnknownFreezerError  | 0     |                                                                                 |
| adamantium/adamantium/freezer.rb#OptionError          | 0     |                                                                                 |
| adamantium/adamantium/freezer.rb#Freezer              | 0     |                                                                                 |
| adamantium/adamantium/freezer.rb#Adamantium           | 0     |                                                                                 |
| adamantium/adamantium/module_methods.rb#ModuleMethods | 2     | [:freezer, :memoize, :memoize_method, :memoized_methods], [:include, :included] |
| adamantium/adamantium/module_methods.rb#Adamantium    | 0     |                                                                                 |
| adamantium/adamantium/mutable.rb#Mutable              | 0     |                                                                                 |
| adamantium/adamantium/mutable.rb#Adamantium           | 0     |                                                                                 |
| adamantium/adamantium/version.rb#Adamantium           | 0     |                                                                                 |
| adamantium/adamantium.rb#Flat                         | 0     |                                                                                 |
| adamantium/adamantium.rb#Adamantium                   | 1     | [:__adamantium_dup__, :transform, :transform_unless]                            |
| hello_world/hello_world.rb#HelloWorld                 | 1     | [:name, :puts, :run]                                                            |
| pizza/lib/pizza.rb#Pizza                              | 2     | [:cost, :title, :toppings], [:likes, :rating, :worse_rating]                    |



## Extending the LCOM4 metric to better suit Ruby

Your final task is to extend the LCOM4 metric to improve its performance for Ruby programs. In particular, you should:

1. Add dependencies between methods that use one or more of the same instance variables. (This is actually a requirement for LCOM4, but we've overlooked this until now). For example, if `bake` uses `@toppings` and `@oven`, and `rating` uses `@toppings` then there should be a dependency between `bake` and `rating`.
2. Recall that Ruby allows getter and setter methods to be specified using the `attr_reader`, `attr_writer` and `attr_accessor` methods. Update your implementation so that the dependencies between `foo` and `@foo` (and between `foo=` and `@foo`) are recorded.
3. In my own testing, it often seemed that a class's constructor (`initialize` method) would cause several otherwise isolated components to be joined together. Experiment with excluding the `initialize` method from the dependency graph. Does this improve your results? If so, why?
4. Ensure that inherited methods are not included in the dependency graph. (This one is quite tricky!)
