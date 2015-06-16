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

| Source File                 | LOC | LOC-W | LOC-C | LOC-WC |
| :-------------------------- | :-- | :---- | :---- | :----- |
| hello_world/hello_world.rb  | 8   | 7     | 7     | 6      |

Note that the command for each metric is as follows:
    * LOC: `scripts/size loc hello_world`
    * LOC-W: `scripts/size loc --no-blanks hello_world`
    * LOC-C: `scripts/size loc --no-comments hello_world`
    * LOC-WC: `scripts/size loc --no-blanks --no-comments hello_world`

For a more thorough test of your implementation, try the `adamantium` sample project by running: `scripts/size loc OPTIONS adamantium`. The exepcted results are:

| Source File                   | LOC | LOC-W | LOC-C | LOC-WC |
| :---------------------------- | :-- | :---- | :---- | :----- |
| adamantium/class_methods.rb   | 21  | 17    | 11    | 7      |
| adamantium/freezer.rb         | 138 | 119   | 69    | 50     |
| adamantium/module_methods.rb  | 66  | 58    | 30    | 22     |
| adamantium/mutable.rb         | 55  | 50    | 15    | 10     |
| adamantium/version.rb         | 8   | 5     | 6     | 3      |
| adamantium.rb                 | 107 | 93    | 59    | 45     |


### Counting structural elements
