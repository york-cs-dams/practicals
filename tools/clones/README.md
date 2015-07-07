# Detecting Clones

This practical covers:

* Implementing (a simplified) Baker's algorithm for clone detection
* ...
* ...

## Building the clone detection

Your first task is to complete the `clones` tool so that it implements Baker's algorithm, which was discussed in the lectures. The code in this repository contains an executable which can be invoked using `scripts/clones detect PROJECT`. Run `scripts/clones help` for more information.

The sample projects in the `data` folder can be used to test the clones tool. To get started, create a straightforward code clone by duplicating `data/hello_world/hello_world.rb` in a new file `data/hello_world/goodbye_world.rb`. Replace all instances of "Hello" with "Goodbye" in `data/hello_world/goodbye_world.rb`

If you run, say, `scripts/clones detect hello_world` you'll notice that the `clones` tool doesn't do much yet:

```
hello_world.rb
--------------

goodbye_world.rb
--------------
```

### Computing common fragments

* Define fragments (array of strings, where each string is a line)
* Define common fragment
* Instruct how to get tests running, and how to start passing them [check bundle install and rspec works on my work desktop]

### Computing longest common fragments

* Define LCF
* Introduce new tests
* Hint: recursive definition will have sig LCF(other_source, longest_yet = [])
* Describe the expected output on adamantium (which will include a load of comments)
* Describe the normalized_source method, how to change clone_detector to use it, and the new expected output on adamanitum (which will include a load of junk)

### Removing junk clones

* Reminder about the structure of a fragment
* Ask to remove fragments that contain keywords such as "end, class, module, self"
* Describe the expected output on adamantium (which will include a load of one-liners)

### Threshold

* Extend LCF to take a threshold parameter. Hint: I ended up with LCF(other_source, threshold = 3, longest_yet = [])
* Describe the expected output on adamantium (which will be empty)

### Extensions (no solutions to these)

* Change the code to list all clones between every pair of files, rather than only the longest clone. Start by changing CloneDetector#clones_between to:

```ruby
def clones_between(source, other_source)
  source.all_common_fragments_with(other_source).map do |common_fragment|
    Clone.new(source, other_source, longest_common_fragment)
  end
end
```

* Implement the parameterised version of Baker's algorithm. Namely, you should preprocess the AST to replace any concrete module, class, method, attribute and variable names to instead by a constant parameter (e.g., `module Measurement` -> `module M` and `module Detection` -> `module D`). This will allow clone detection for semantically equivalent but syntatically different fragments.
