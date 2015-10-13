# Detecting Clones

This practical covers:

* Implementing (a simplified) Baker's algorithm for clone detection
* Improving on Baker's algorithm with some practical optimisations

## Building the clone detection tool

Your first task is to complete the `clones` tool so that it implements Baker's algorithm, which was discussed in the lectures. The code in this repository contains an executable which can be invoked using `vado clones detect PROJECT`. Run `vado clones help` for more information.

The sample projects in the `data` folder can be used to test the clones tool. To get started, create a straightforward code clone by duplicating `data/hello_world/hello_world.rb` in a new file `data/hello_world/goodbye_world.rb`. Replace all instances of "Hello" with "Goodbye" in `data/hello_world/goodbye_world.rb`

If you run, say, `vado clones detect hello_world` you'll notice that the `clones` tool doesn't do much yet:

```
hello_world.rb
--------------

goodbye_world.rb
--------------
```

### Computing common fragments

A simple yet reasonably effective way to identify code clones is to locate identical parts of two source files. For the purposes of this practical, we'll use the term fragment to mean "a part of a source file" and we'll restrict ourselves to thinking about breaking source files down by line. To identify a fragment, we'll use the notation `hello_world.rb:2..4` which can be read as "lines 2 to 4 of hello_world.rb". We'll represent a fragment as an array of strings, where each member of the array is a line of source code. So, "hello_world.rb:2..4" will be equivalent to:

```ruby
[
  "  class HelloWorld",
  "    attr_reader :name",
  ""
]
```

Your first task is to implement a method that compares two pieces of source code and identifies fragments that they have in common. Note that, for now, this method will return only one common fragment (i.e., an array of strings) and not an array of all common fragments (i.e., not an array of array of strings). Some test cases have been provided to explain the intended functionality of the common fragments algorithm. Use `vado bundle exec rspec` to run the test cases. The first time that you run the tests, you will see several failures:

```sh
> vado bundle exec rspec
...
Failed examples:

rspec ./habitable_programs/tools/common/spec/subjects/source_spec.rb:6 # Subjects::Source common_fragment_with should find first fragment of appropriate length
rspec ./habitable_programs/tools/common/spec/subjects/source_spec.rb:13 # Subjects::Source common_fragment_with should find first fragment of appropriate length when match occurs in middle of sources
rspec ./habitable_programs/tools/common/spec/subjects/source_spec.rb:20 # Subjects::Source common_fragment_with should return nil when there is no common fragment
rspec ./habitable_programs/tools/common/spec/subjects/source_spec.rb:27 # Subjects::Source common_fragment_with should find fragments when length is larger than 1
rspec ./habitable_programs/tools/common/spec/subjects/source_spec.rb:34 # Subjects::Source common_fragment_with should return nil when there is no fragment of the appropriate length
```

You can examine the expected behaviour of the common fragment method by looking at the failures and at the test case source code in `./habitable_programs/tools/common/spec/subjects/source_spec.rb`. Your implementation of the common fragment algorithm should be specified in the `common_fragment_with` method of `./habitable_programs/tools/common/lib/subjects/source.rb`.


### Computing longest common fragments

Next, implement the `longest_common_fragment_with` method to locate common fragments with at least as many lines as any other common fragment. Once again, there are some test cases that you can use to get started. In `./habitable_programs/tools/common/spec/subjects/source_spec` change the `xdescribe` on line 43 to `describe` and run `vado bundle exec rspec`. You will see some new failures:

```sh
> vado bundle exec rspec
...
rspec ./habitable_programs/tools/common/spec/subjects/source_spec.rb:44 # Subjects::Source longest_common_fragment_with should find longest common fragment between two sources
```

Your implementation of the longest common fragment algorithm should be specified in the `longest_common_fragment_with` method of `./habitable_programs/tools/common/lib/subjects/source.rb`. Hint: a recursive solution will change the method signature to `longest_common_fragment_with(other_source, longest_yet = [])`.

Once the `longest_common_fragment_with` method is complete, you can start using the `clones` tool to identify code clones within a project. For example, running `vado clones detect hello_world` will produce some useful output:

```ruby
# goodbye_world.rb
# ----------------
# hello_world.rb:2..9 matches 2..9:
  attr_reader :name

  def initialize(name = "world")
    @name = name
  end

  def run

# hello_world.rb
# --------------
# goodbye_world.rb:2..9 matches 2..9:
  attr_reader :name

  def initialize(name = "world")
    @name = name
  end

  def run
```

## Improving the clone detection tool

When running the initial implementation of `clones` on more realistic projects, it becomes apparent that it often reports false positives (i.e., fragments of text that are not code clones, or that are not interesting code clones). For example, running `vado clones detect adamantium` will return lots of fragments that return comments and common Ruby keywords. Let's fix this...

The most reliable way to remove comments from Ruby source code is to use the Ruby parser to build an AST (which strips away comments by default) and then to use the unparser to pretty print the AST. The `Source` file provides a `normalized_source` method that strips comments using these technique. To make use of this, simply change line 20 of `./habitable_programs/tools/clones/lib/clone_detector.rb` to read: `.flat_map { |other_file| clones_between(file.normalized_source, other_file.normalized_source) }`. Once the `clones` tool ignores comments, it will identify fewer clones for adamantium:

```sh
> vado clones detect adamantium
adamantium/class_methods.rb
---------------------------
adamantium/mutable.rb:7..10 matches 4..7:
    end
  end
end
adamantium/module_methods.rb:26..29 matches 4..7:
    end
  end
end
adamantium/freezer.rb:53..56 matches 4..7:
    end
  end
end
adamantium.rb:24..26 matches 4..6:
    end
  end
adamantium/version.rb:0..1 matches 0..1:
module Adamantium

adamantium/freezer.rb
---------------------
adamantium.rb:23..26 matches 52..55:
      end
    end
  end
adamantium/mutable.rb:7..10 matches 53..56:
    end
  end
end
adamantium/module_methods.rb:26..29 matches 53..56:
    end
  end
end
adamantium/class_methods.rb:4..7 matches 53..56:
    end
  end
end
adamantium/version.rb:0..1 matches 0..1:
module Adamantium

adamantium/module_methods.rb
----------------------------
adamantium/mutable.rb:7..10 matches 26..29:
    end
  end
end
adamantium/freezer.rb:53..56 matches 26..29:
    end
  end
end
adamantium/class_methods.rb:4..7 matches 26..29:
    end
  end
end
adamantium.rb:12..14 matches 22..24:
      end
    end
adamantium/version.rb:0..1 matches 0..1:
module Adamantium

adamantium/mutable.rb
---------------------
adamantium/module_methods.rb:26..29 matches 7..10:
    end
  end
end
adamantium/freezer.rb:53..56 matches 7..10:
    end
  end
end
adamantium/class_methods.rb:4..7 matches 7..10:
    end
  end
end
adamantium.rb:24..26 matches 7..9:
    end
  end
adamantium/version.rb:0..1 matches 0..1:
module Adamantium

adamantium/version.rb
---------------------
adamantium.rb:2..3 matches 0..1:
module Adamantium
adamantium/mutable.rb:0..1 matches 0..1:
module Adamantium
adamantium/module_methods.rb:0..1 matches 0..1:
module Adamantium
adamantium/freezer.rb:0..1 matches 0..1:
module Adamantium
adamantium/class_methods.rb:0..1 matches 0..1:
module Adamantium

adamantium.rb
-------------
adamantium/freezer.rb:52..55 matches 23..26:
      end
    end
  end
adamantium/mutable.rb:7..9 matches 24..26:
    end
  end
adamantium/module_methods.rb:22..24 matches 12..14:
      end
    end
adamantium/class_methods.rb:4..6 matches 24..26:
    end
  end
adamantium/version.rb:0..1 matches 2..3:
module Adamantium
```

Removing uninteresting code clones (e.g., a series of `end` keywords) is a bit tricker, and is your next task. Change the implementation of Source to ignore fragments whose lines only contain the `end`, `class`, `module` and `self` keywords. Once the `clones` tool ignores these uninteresting fragments, it will identify fewer clones for adamantium:

```sh
> vado clones detect adamantium
adamantium/class_methods.rb
---------------------------

adamantium/freezer.rb
---------------------
adamantium/module_methods.rb:8..9 matches 7..8:
      else

adamantium/module_methods.rb
----------------------------
adamantium.rb:4..5 matches 2..3:
    def freezer
adamantium/freezer.rb:7..8 matches 8..9:
      else

adamantium/mutable.rb
---------------------

adamantium/version.rb
---------------------

adamantium.rb
-------------
adamantium/module_methods.rb:2..3 matches 4..5:
    def freezer
```

Note that the remaining clones are only one line long. One-line clones are really interesting. Let's fix this...

Change `longest_common_fragment` (and its tests) to take an additional `threshold (int)` parameter. The new version of `longest_common_fragment_with` must not return any fragment that has fewer lines than the threshold parameter (and can instead return `[]`). Hint: the recursive solution results in the method signature `longest_common_fragment_with(other_source, threshold = 2, longest_yet = [])`

Once this change has been made, running `clones` on adamantium will correctly report that there are no (interesting) code clones. Ensure that this latest version of `clones` can still detect the code clone that you introduced at the start of the practical, in `goodbye_world.rb`.

## Bonus Exercise: Making the clone detection tool even better

Currently the `clones` tool has several deficiencies. Address the most obvious of these by:

### Listing **all** clones between every pair of files

Start by changing CloneDetector#clones_between to:

```ruby
def clones_between(source, other_source)
  source.all_common_fragments_with(other_source).map do |common_fragment|
    Clone.new(source, other_source, longest_common_fragment)
  end
end
```

Now implement `all_common_fragments_with` on Source. An outstanding implementation of this method will ensure that the results contain no overlapping fragments. For example, if `hello_world.rb:5-20` is a fragment, then `hello_world.rb:6-19` should not be returned (because the latter is wholly contained in the former).

### Implementing the **parameterised** version of Baker's algorithm

Preprocess the AST to replace any concrete module, class, method, attribute and variable names with a constant (e.g., `module Measurement` -> `module M` and `module Detection` -> `module D`). This will allow clone detection for semantically equivalent but syntactically different fragments.

Start by adding a new method SourceFile, say `parameterized_source`, that performs this preprocessing. Then, change line 20 of `./habitable_programs/tools/clones/lib/clone_detector.rb` to read: `.flat_map { |other_file| clones_between(file.parameterized_source, other_file.parameterized_source) }`.


## Remediation

### Bonus: extract a Fragment class from Source
