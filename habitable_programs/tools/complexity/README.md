# Measuring Complexity

This practical covers:

* Implementing the ABC metric for measuring the complexity of methods
* ...
* ...

## Building the complexity tool

Your first task is to complete the `complexity` tool so that it implements the ABC metric, which was discussed in the lectures. The code in this repository contains an executable which can be invoked using `vado complexity abc PROJECT`. Run `vado complexity help` for more information.

The sample projects in the `data` folder can be used to test the complexity tool.

If you run, say, `vado complexity abc hello_world` you'll notice that the `complexity tool` doesn't do much yet:

| Subject                   | assignments | branches | conditions | abc |
| hello_world.rb#initialize | 0           | 0        | 0          | 0.0 |
| hello_world.rb#run        | 0           | 0        | 0          | 0.0 |

Recall that the ABC metric is computed as the magnitude of the vector that counts:

* Assignments - a variable is initialised or updated
* Branches - a method is called
* Conditions - a part of the program is executed only some of the time

The implementation of computing ABC from A, B and C is already complete (see `lib/measurement/abc_measurer.rb` if you are curious). You will need to complete the implementations for computing the number of assignments, branches and conditions in a method.

### Measuring assignments

Starting with the `AssignmentCounter` class (in `lib/measurement/assignment_counter.rb`), consider how to count the following types of Ruby statement:

* An assignment to a local variable: e.g., `name = "Bob"`
* An assignment to an instance variable: e.g., `@name = "Bob"`
* An operator assignment to a (local or instance) variable via an operation: e.g., `@surname ||= "Smith"` or `age += 1`
* A multiple assignment: e.g., `first, *middle, last = my_array`

Note that `AssignmentCounter` is a subclass of `Counter` which in turn is a subclass of `AST::Processor`. For a recap on Abstract Syntax Trees and `Parser::AST::Processor`, see the lecture on the Ruby Parser.

Test your implementation on the `hello_world` project by running `vado complexity abc hello_world`. The expected results are:

| Subject                   | assignments |
| :------------------------ | :---------- |
| hello_world.rb#initialize | 1           |
| hello_world.rb#run        | 0           |

For a more thorough test of your implementation, try the `adamantium` sample project by running: `vado complexity abc adamantium`. The expected results are:

| Subject                                     | assignments |
| :------------------------------------------ | :---------- |
| adamantium/class_methods.rb#new             | 0           |
| adamantium/module_methods.rb#freezer        | 0           |
| adamantium/module_methods.rb#memoize        | 2           |
| adamantium/module_methods.rb#included       | 0           |
| adamantium/module_methods.rb#memoize_method | 0           |
| adamantium/mutable.rb#freeze                | 0           |
| adamantium/mutable.rb#frozen?               | 0           |
| adamantium.rb#freezer                       | 0           |
| adamantium.rb#dup                           | 0           |
| adamantium.rb#transform                     | 1           |
| adamantium.rb#transform_unless              | 0           |


### Measuring branches

Next, extend `BranchCounter` class (in `lib/measurement/branch_counter.rb`) to count the following types of Ruby statement:

* Method calls (i.e., sending a message to an object): e.g. `42.to_f`

Ensure that your implementation **does not** count:

* Calls to methods that are already in scope, such as other methods on the current class or methods on Kernel (e.g., `puts`). Note that the receiver of these method calls is unspecified: the Ruby parser lists them as `nil`.
* Method calls to the conditional operators. Namely these are: `== != <= >= < >`

Test your implementation on the `hello_world` project by running `vado complexity abc hello_world`. The expected results are:

| Subject                   | branches |
| :------------------------ | :------- |
| hello_world.rb#initialize | 0        |
| hello_world.rb#run        | 0        |

For a more useful test of your implementation (!) try the `adamantium` sample project by running: `vado complexity abc adamantium`. The expected results are:

| Subject                                     | branches |
| :------------------------------------------ | :------- |
| adamantium/class_methods.rb#new             | 1        |
| adamantium/module_methods.rb#freezer        | 0        |
| adamantium/module_methods.rb#memoize        | 5        |
| adamantium/module_methods.rb#included       | 1        |
| adamantium/module_methods.rb#memoize_method | 3        |
| adamantium/mutable.rb#freeze                | 0        |
| adamantium/mutable.rb#frozen?               | 0        |
| adamantium.rb#freezer                       | 0        |
| adamantium.rb#dup                           | 0        |
| adamantium.rb#transform                     | 4        |
| adamantium.rb#transform_unless              | 0        |

### Measuring conditions

Finally, extend `ConditionCounter` (in `lib/measurement/condition_counter.rb` to count the following types of Ruby statement:

* Conditional operators (i.e., calls to conditional operator methods): e.g., `a == b` or `age > 18`
* If expressions, but only if they have an else part.
* Unless expressions, but only if they have an else part.
* Ternary if expressions: e.g., `is_morning ? 'AM' : 'PM'`
* Binary conditional operators: e.g., `a || b` or `c && d`
* Case expressions, where every `when` part is counted and any `else` part is counted.
* Rescue blocks.

Test your implementation on the `hello_world` project by running `vado complexity abc hello_world`. The expected results are:

| Subject                   | conditions |
| :------------------------ | :--------- |
| hello_world.rb#initialize | 0          |
| hello_world.rb#run        | 0          |

For a much more useful test of your implementation (!) try the `adamantium` sample project by running: `vado complexity abc adamantium`. The expected results are:

| Subject                                     |  conditions |
| :------------------------------------------ | :---------- |
| adamantium/class_methods.rb#new             |  0          |
| adamantium/module_methods.rb#freezer        |  0          |
| adamantium/module_methods.rb#memoize        |  2          |
| adamantium/module_methods.rb#included       |  0          |
| adamantium/module_methods.rb#memoize_method |  0          |
| adamantium/mutable.rb#freeze                |  0          |
| adamantium/mutable.rb#frozen?               |  0          |
| adamantium.rb#freezer                       |  0          |
| adamantium.rb#dup                           |  0          |
| adamantium.rb#transform                     |  0          |
| adamantium.rb#transform_unless              |  1          |
