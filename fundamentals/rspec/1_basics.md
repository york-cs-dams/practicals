# An RSpec tutorial, part 1

This three-part tutorial introduces RSpec, one of the most popular (unit) testing frameworks for Ruby.

This first part covers:

* How to install and use RSpec
* Writing and running unit tests ("specs") with RSpec
* A few of the most common assertions ("expectations") used with RSpec

The [second part](2_doubles.md) of this tutorial covers test doubles (stubbing, mocking and spying with RSpec), and the [third part](3_integration.md) integration testing with RSpec.

*Note that this tutorial will not work with the Ruby installation on the CS student lab machines. You can instead use the Vagrant setup for DAMS practicals as discussed in at the end of the [Vagrant tutorial](../tools/vagrant.md).*


## Installing RSpec

If you are using the DAMS Vagrant VM for the practical classes or for the assessment, RSpec is already installed for you. That was easy.

If you want to run RSpec on another machine, you can run `gem install rspec`. If you need to install Ruby, [see the Ruby tutorial](../1_introduction.md) or come and find me!


## Writing and running RSpec unit tests

After [cloning](../../README.md) this repository, open the file `fundamentals/rspec/calculator/spec/max_spec.rb` in your favourite editor. You should see the following code:

```ruby
require_relative "max"

module Calculator
  describe Max do
    it "returns correct answer for a tie" do
      expect(Max.new.run(4, 4)).to eq(4)
    end

    it "returns correct answer when first is larger" do
      expect(Max.new.run(4, 3)).to eq(4)
    end

    it "returns correct answer when last is larger" do
      # your code
    end
  end
end
```

An RSpec unit test comprises the following imporant elements:

* A `describe` block, which identifies the class that is being tested. Note that, above, the describe block is nested in a module, so the class under test is `Calculator::Max`.
* Several `it` blocks, each of which represent a single test case for the class being tested. Test cases comprise a human-readable title, and the Ruby code needed to run the test.
* An `expect` statement for each test case, which are the conditions that must hold in order for the test case to pass. Note that the `expect` statement is always follow by a call to `.to` followed by a matcher. We'll look at matchers at the end of this tutorial.

Note that the final test case has not been completed. Add an assertion of the form `expect(...).to eq(X)`.

Run your tests with `vado rake test:rspec:calculator`. You should see the following output:

```
...

Finished in 2 seconds (files took 0.3467 seconds to load)
3 examples, 0 failures
```

Now, let's deliberately break one of the tests:

```ruby
    it "returns correct answer for a tie" do
      expect(Max.new.run(4, 4)).to eq(400)
    end
```

Q1. What happens when you rerun the tests? How does the output from RSpec help you to understand which tests is failing and why?

### Subjects

In the RSpec test suite for `Max#run`, every test case contains the code `Max.new`. This is slightly brittle, because the name of the Max class could change. To clean up this repetition, use RSpec's subject syntax:


```ruby
require "calculator/max"

module Calculator
  describe Max do
    subject { Max.new }  # Specifies how subject should be created

    it "returns correct answer for a tie" do  # Uses subject
      expect(subject.run(4, 4)).to eq(4)  
    end

    it "returns correct answer when first is larger" do  # Uses subject
      expect(subject.run(4, 3)).to eq(4)
    end

    it "returns correct answer when last is larger" do
      # your code
    end
  end
end
```


### Contexts

It can sometimes be useful to group test cases together under subheadings. This can be achieved by using RSpec's `context` syntax:

```ruby
require "calculator/max"

module Calculator
  describe Max do
    subject { Max.new }

    context "for valid inputs" do
      it "returns correct answer for a tie" do
        expect(subject.run(4, 4)).to eq(4)  
      end

      it "returns correct answer when first is larger" do
        expect(subject.run(4, 3)).to eq(4)
      end

      it "returns correct answer when last is larger" do
         # your code
      end
    end

    context "for invalid inputs" do
      it "should explode loudly" do
        expect { subject.run("foo", :bar) }.to raise_error
      end
    end
  end
end
```

## Common RSpec Matchers

In RSpec, matchers are used to specify assertions (or "expectations"). We've seen two matchers already, `eq` and `raise_error`.

Take a look at the [RSpec documentation for `eq`](http://rspec.info/documentation/3.3/rspec-expectations/#Equivalence), and then continue reading this page to become familiar with the other built-in matchers.

That's it for the first part of this RSpec tutorial. Move on to the [second part](2_doubles.md) to learn about test doubles.
