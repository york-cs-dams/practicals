# Measuring Size

This practical covers:

* Evaluating the habitability of a system by measuring its size
* Applying the measures to decide how to improve the habitability of a system
* Reflecting on the limitations of size metrics

You are to build a tool that can automatically measure the size of Ruby programs. The tool will implement the size metrics discussed in the lectures.


## Building the size tool

Your first task is to complete the `size` tool so that it implements all of the metrics discussed in the lectures.

### Counting lines of code

Starting with the `LOC` class (in `lib/size/loc.rb`), implement the metrics below. Note that the command to run for each metric is shown in brackets.

* Lines of code per source file. (`scripts/size loc`)
* Lines of code per source file excluding whitespace. (`scripts/size loc --no-blanks`)
* Lines of code per source file excluding comments. (`scripts/size loc --no-comments`)
* Lines of code per source file excluding whitespace and comments. (`scripts/size loc --no-blanks --no-comments`)

Note that the `LOC` class provides the `@include_blanks` attribute which returns false iff the `--no-blanks` flags are passed in on the command line. The `@include_comments` attribute provides the same functionality for the `--no-comments` flag.

The sample projects in the `data` folder can be used to test your implementation. Start with the simplest sample project, `hello_world` by running: `scripts/size loc OPTIONS hello_world`. The expected results are:

| Source File                 | LOC | LOC-B | LOC-C | LOC-BC |
| :-------------------------- | :-- | :---- | :---- | :----- |
| hello_world/hello_world.rb  | 14  | 11    | 13    | 10     |

Note that the command for each metric is as follows:

* LOC: `scripts/size loc hello_world`
* LOC-B: `scripts/size loc --no-blanks hello_world`
* LOC-C: `scripts/size loc --no-comments hello_world`
* LOC-BC: `scripts/size loc --no-blanks --no-comments hello_world`

For a more thorough test of your implementation, try the `adamantium` sample project by running: `scripts/size loc OPTIONS adamantium`. The exepcted results are:

| Source File                   | LOC | LOC-B | LOC-C | LOC-BC |
| :---------------------------- | :-- | :---- | :---- | :----- |
| adamantium/class_methods.rb   | 21  | 17    | 11    | 7      |
| adamantium/freezer.rb         | 138 | 119   | 69    | 50     |
| adamantium/module_methods.rb  | 66  | 58    | 30    | 22     |
| adamantium/mutable.rb         | 55  | 50    | 15    | 10     |
| adamantium/version.rb         | 8   | 5     | 6     | 3      |
| adamantium.rb                 | 107 | 93    | 59    | 45     |


### Counting structural elements

Next, extend `lib/size/elements.rb` to implement the metrics below. Note that the command to run for each metric is shown in brackets.

* Number of classes per source file. (`scripts/size elements`)
* Number of modules per source file. (`scripts/size elements --type=modules`)
* Number of methods per source file. (`scripts/size elements --type=methods`)
* Number of class methods per source file. (`scripts/size elements --type=class_methods`)
* Number of attributes per source file. (`scripts/size elements --type=attributes`)

Note that the implementation of the `Elements` class is already complete. The subclasses of `Counter` need to be completed. Each subclass `Counter` is an AST Processor and responds to `on_XXX` methods. (See the lectures on the Ruby parser for more information).

The implementations of ClassCounter, MethodCounter and ClassMethodCounter are very similar to the implementation of ModuleCounter. The implementation of AttributeCounter requires a bit more thought. Consider the following examples:

```ruby
class Hello
  def initialize(name)
    @name = name
  end

  def run
    puts "Hello, #{@name}!"
  end
end
```

Here, `@name` will appear twice in the abstract syntax tree, but we only wish to count the number of distinct attributes (instance variables). In other words, for this program our attribute counter should return a count of 1.

```ruby
class Hello2
  attr_accessor :name

  def run
    puts "Hello, #{name}!"
  end
end
```

And here, it appears that there are no attributes (instance variables) at first glance. However, recall that `attr_accessor` (and `attr_reader` and `attr_writer`) are Ruby shorthands for defining attributes (along with getter and/or setter methods). For this program, name is an instance variable and our attribute counter should return a count of 1.

The sample projects in the `data` folder can be used to test your implementation. Start with the simplest sample project, `hello_world` by running: `scripts/size loc OPTIONS hello_world`. The expected results are:

| Source File                 | CLASSES | MODULES | METHODS | CMETHODS | ATTRIBUTES |
| :-------------------------- | :------ | :------ | :------ | :------- | :--------- |
| hello_world/hello_world.rb  | 1       | 0       | 2       | 0        | 1          |

Note that the command for each metric is as follows:

* CLASSES: `scripts/size elements hello_world`
* MODULES: `scripts/size elements --type=modules hello_world`
* METHODS: `scripts/size elements --type=methods hello_world`
* CMETHODS: `scripts/size elements --type=class_methods hello_world`
* ATTRIBUTES: `scripts/size elements --type=attributes hello_world`

scripts/size elements --type=classes adamantium
scripts/size elements --type=modules adamantium
scripts/size elements --type=methods adamantium
scripts/size elements --type=class_methods adamantium
scripts/size elements --type=attributes adamantium

For a more thorough test of your implementation, try the `adamantium` sample project by running: `scripts/size loc OPTIONS adamantium`. The exepcted results are:

| Source File                   | CLASSES | MODULES | METHODS | CMETHODS | ATTRIBUTES |
| :---------------------------- | :------ | :------ | :------ | :------- | :--------- |
| adamantium/class_methods.rb   | 0       | 2       | 1       | 0        | 0          |
| adamantium/freezer.rb         | 5       | 1       | 0       | 6        | 1          |
| adamantium/module_methods.rb  | 0       | 2       | 4       | 0        | 0          |
| adamantium/mutable.rb         | 0       | 2       | 2       | 0        | 0          |
| adamantium/version.rb         | 0       | 1       | 0       | 0        | 0          |
| adamantium.rb                 | 0       | 2       | 4       | 2        | 0          |
