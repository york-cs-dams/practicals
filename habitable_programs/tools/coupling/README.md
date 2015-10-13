# Measuring Coupling

This practical covers:

* Implementing the MPC metric for measuring coupling
* ...
* Investigating how the CBO metric can be implemented for dynamic languages like Ruby

## Building the coupling tool

Your first task is to complete the `coupling` tool so that it implements the MPC metric, which was discussed in the lectures. The code in this repository contains an executable which can be invoked using `vado coupling mpc PROJECT`. Run `vado coupling help` for more information.

The sample projects in the `data` folder can be used to test the complexity tool.

If you run, say, `vado coupling mpc hello_world` you'll notice that the `coupling` tool already reports some values:

| Subject                               | total_messages_passed | messages_passed_to_self | messages_passed_to_ancestors | mpc |
| :------------------------------------ | :-------------------- | :---------------------- | :--------------------------- | :-- |
| hello_world/hello_world.rb#initialize | 0                     | 0                       | 0                            | 0   |
| hello_world/hello_world.rb#run        | 2                     | 0                       | 0                            | 2   |

Recall that the MPC metric is computed as: Total Messages - (Messages To Self + Messages To Ancestors)

The implementation of computing MPC and Total Messages is already complete (see `lib/measurement/mpc_measurer.rb`). You will need to complete the implementations for computing the number of messages to self and messages to ancestors. For the later, note that only messages sent explicitly to the receiver `super` are messages passed to ancestors in Ruby.

Apply the completed tool to the sample projects using `vado coupling mpc`. The expected results are:

| Subject                                                | total_messages_passed | messages_passed_to_self | messages_passed_to_ancestors | mpc |
| :----------------------------------------------------- | :-------------------- | :---------------------- | :--------------------------- | :-- |
| adamantium/adamantium/class_methods.rb#new             | 2                     | 1                       | 0                            | 1   |
| adamantium/adamantium/module_methods.rb#freezer        | 0                     | 0                       | 0                            | 0   |
| adamantium/adamantium/module_methods.rb#memoize        | 7                     | 2                       | 0                            | 5   |
| adamantium/adamantium/module_methods.rb#included       | 2                     | 1                       | 0                            | 1   |
| adamantium/adamantium/module_methods.rb#memoize_method | 4                     | 1                       | 0                            | 3   |
| adamantium/adamantium/mutable.rb#freeze                | 0                     | 0                       | 0                            | 0   |
| adamantium/adamantium/mutable.rb#frozen?               | 0                     | 0                       | 0                            | 0   |
| adamantium/adamantium.rb#freezer                       | 0                     | 0                       | 0                            | 0   |
| adamantium/adamantium.rb#dup                           | 0                     | 0                       | 0                            | 0   |
| adamantium/adamantium.rb#transform                     | 5                     | 1                       | 0                            | 4   |
| adamantium/adamantium.rb#transform_unless              | 1                     | 1                       | 0                            | 0   |
| hello_world/hello_world.rb#initialize                  | 0                     | 0                       | 0                            | 0   |
| hello_world/hello_world.rb#run                         | 2                     | 2                       | 0                            | 0   |


## Prototyping the CBO metric

Your final task is to invesigate how to implement the CBO metric, which was discussed in the lectures. CBO requires information about the types in the system, and (for dynamically typed languages like Ruby) is quite inaccurate, expensive (or both!) when calculated statically (i.e., by inspecting source code without running it). Instead, it is often cheaper and more accurate to calculate CBO at runtime.

Ruby provides a built-in runtime tracing library for monitoring the execution of a program, which you should use to implement the CBO metric:

1. Explore how the [TracePoint](http://ruby-doc.org/core-2.2.2/TracePoint.html) class can be used to monitor the runtime execution of a Ruby program.
2. Build a simple script that uses a TracePoint to monitor method calls and returns during the execution of an example program (comprising at least 2 collaborating classes).
3. Collect the data necessary to build a Hash where keys are of the form "Class#method" and the values are an array of "Class#method".
4. Use the Hash to calculate a CBO score for every member of the Hash (NB: now that you've done the hard work, this step should be easy!)
5. Compare the MPC and CBO scores for your example program (step 2). How do they differ? Which code smells can each metric be used to detect?
