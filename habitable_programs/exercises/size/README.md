# Measuring Size

This practical covers:

1. Evaluating the habitability of a system by measuring its size
2. Applying the measures to decide how to improve the habitability of a program
3. Refactorings that improve the habitability of a program by reducing the size of its parts

## 1. Building the size tool

Your first task is to build a tool, called `size`, that implements all of the metrics discussed in the lectures. A partial implementation has been provided: the code in this repository contains an executable which can be invoked using `vado size ...`. Run `vado size help` for more information.

The sample projects in the `data` folder can be used to test the size tool. If you run, say, `vado size files hello_world` you'll notice that the size tool doesn't do much yet:

| Subject        | lines_of_code | number_of_modules | number_of_classes |
| :------------- | :------------ | :---------------- | :---------------- |
| hello_world.rb | ?             | ?                 | ?                 |

### Measuring files

Starting with the `FileMeasurer` class (in `./lib/measurement/file_measurer.rb`), implement the metrics below.

* Lines of code per source file.
* Number of modules per source file.
* Number of classes per source file.

Note that each of the methods named `count_XXX` receive a file object. This is an instance of `Subjects::SourceFile` (in `../common/lib/subjects/source_file.rb`). `SourceFile` provides two methods that you will need: `source` returns the file's source code and `ast` returns the file's Abstract Syntax Tree. You'll also want to make use of the parser gem's `Parser::AST::Processor` class. For a recap on Abstract Syntax Trees and `Parser::AST::Processor`, see the DAMS lecture on the Ruby Parser.

Test your implementation on the `hello_world` project by running `vado size files hello_world`. The expected results are:

| Subject        | lines_of_code | number_of_modules | number_of_classes |
| :------------- | :------------ | :---------------- | :---------------- |
| hello_world.rb | 14           | 0                 | 1                 |

For a more thorough test of your implementation, try the `adamantium` sample project by running: `vado size files adamantium`. The expected results are:

| Subject                      | lines_of_code | number_of_modules | number_of_classes |
| :--------------------------- | :------------ | :---------------- | :---------------- |
| adamantium/class_methods.rb  | 19            | 2                 | 0                 |
| adamantium/freezer.rb        | 136           | 1                 | 5                 |
| adamantium/module_methods.rb | 64            | 2                 | 0                 |
| adamantium/mutable.rb        | 53            | 2                 | 0                 |
| adamantium/version.rb        | 6             | 1                 | 0                 |
| adamantium.rb                | 105           | 2                 | 0                 |


### Measuring classes

Next, extend `ClassMeasurer` (in `./lib/measurement/class_measurer.rb`) to implement the metrics below.

* Lines of code per class.
* Number of methods per class.
* Number of class methods per class.
* Number of attributes per class.

Note that each of the methods named `count_XXX` receive a class object. This is an instance of `Subjects::Class` (in `../common/lib/subjects/class.rb`) and, just like `SourceFile`, provides `source` and `ast` methods which you'll want to use.

Implementing the first 3 metrics will likely lead to code that is very similar to the metrics you have implemented in `FileMeasurer`. For the final metric (counting attributes), the implementation will require a bit more thought. Consider the following examples:

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

Test your implementation on the `hello_world` project by running `vado size classes hello_world`. The expected results are:

| Subject                   | lines_of_code | number_of_methods | number_of_class_methods | number_of_attributes |
| :------------------------ | :------------ | :---------------- | :---------------------- | :------------------- |
| hello_world.rb#HelloWorld | 11            | 2                 | 0                       | 1                    |


For a more thorough test of your implementation, try the `adamantium` sample project by running: `vado size classes adamantium`. The expected results are:

| Subject                                   | lines_of_code | number_of_methods | number_of_class_methods | number_of_attributes |
| :---------------------------------------- | :------------ | :---------------- | :---------------------- | :------------------- |
| adamantium/freezer.rb#Flat                | 15            | 0                 | 1                       | 0                    |
| adamantium/freezer.rb#Deep                | 15            | 0                 | 1                       | 0                    |
| adamantium/freezer.rb#UnknownFreezerError | 1             | 0                 | 0                       | 0                    |
| adamantium/freezer.rb#OptionError         | 1             | 0                 | 0                       | 0                    |
| adamantium/freezer.rb#Freezer             | 128           | 0                 | 6                       | 1                    |


### Measuring methods

Finally, extend MethodMeasurer (in `./lib/measurement/method_measurer.rb` to implement the metrics below.

* Lines of code per method.
* Number of parameters per method.

Note that each of the methods named `count_XXX` receive a method object (an instance of `../common/lib/subjects/method.rb`).

Test your implementation on the `hello_world` project by running `vado size methods hello_world`. The expected results are:

| Subject                   | lines_of_code | number_of_parameters |
| :------------------------ | :------------ | :------------------- |
| hello_world.rb#initialize | 3             | 1                    |
| hello_world.rb#run        | 3             | 0                    |


For a more thorough test of your implementation, try the `adamantium` sample project by running: `vado size methods adamantium`. The expected results are:

| Subject                                     | lines_of_code | number_of_parameters |
| :------------------------------------------ | :------------ | :------------------- |
| adamantium/class_methods.rb#new             | 3             | 1                    |
| adamantium/module_methods.rb#freezer        | 3             | 0                    |
| adamantium/module_methods.rb#memoize        | 6             | 1                    |
| adamantium/module_methods.rb#included       | 4             | 1                    |
| adamantium/module_methods.rb#memoize_method | 4             | 2                    |
| adamantium/mutable.rb#freeze                | 3             | 0                    |
| adamantium/mutable.rb#frozen?               | 3             | 0                    |
| adamantium.rb#freezer                       | 3             | 0                    |
| adamantium.rb#dup                           | 3             | 0                    |
| adamantium.rb#transform                     | 5             | 1                    |
| adamantium.rb#transform_unless              | 3             | 2                    |


## 2. Applying the size tool

Now that you have a working version of the `size` tool, your task is to improve the code of a [series of web scraping scripts](../../data/scraper) that I have written. First of all, apply the `size` tool to find the largest files, classes and methods: `vado size MODE scraper`.

Which files and classes have the most lines of code? Which methods have the most lines of code? Are the longest methods in the longest classes?

Look for methods that dominate their source files. These are likely to be good candidates for refactoring.


## 3. Refactoring long methods

Now that you have found a long method or two in my [series of web scraping scripts](../../data/scraper), you can refactor to improve habitability. First of all, read the source code to see what the script is trying to achieve. ([when.rb](../../data/scraper/when.rb), for example continues quite a lot of detailed comments).

Next, figure out what your chosen script is supposed to do, as there are no automated tests for these scripts (surprise!). For example, run your chosen script for a few different inputs, such as: `vado scrape when.rb DAMS` and `vado scrape when.rb HACS`

Apply several extract method refactorings (as described in [the lecture](http://dams.flippd.it/videos/11)) to improve the code. You will likely need to think carefully about how data flows through the existing methods to identify reasonable boundaries at which the long method can be broken down into small pieces. Try a few different extractions, and each time check that you have not broken the code by running the scripts. Compare your final version with a classmate: explain and justify your designs to each other.
