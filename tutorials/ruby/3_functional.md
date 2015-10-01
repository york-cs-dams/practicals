# A Ruby tutorial, part 3

This three-part tutorial introduces Ruby, object-oriented programming in Ruby, and functional programming in Ruby.

This third part covers functional programming in Ruby, and more specifically:

* The characteristics of Ruby which make it amenable to functional programming
* How to define Ruby closures, and how to use them to program in a functional style
* How to use the built-in Enumerable module to program in a functional style

The [first part](1_introduction.md) covered installation and the key Ruby data types, and the [second part](2_object_oriented.md) object-oriented programming in Ruby.

## Functional Programming in Ruby

Although Ruby is an object-oriented language, it can be used to program in a functional style and many Rubyists do so.

So, is Ruby a functional programming language? Perhaps. It has many qualities which facilitate a functional style of programming:

* Functions are first-class. In Ruby, a function is an object (just like any other value). We can assign a function to a variable, ask for its type (`Proc`), and send messages to it (such as `call` and `arity`).
* Functions can be higher-order. A function can take another function as a parameter.
* Functions can be recursive. Ruby 1.9 onwards also support an optimisation (tail-calls) that makes recursion more efficient.
* Some data-structures can be evaluated lazily.

Purity, however, is one quality of functional programming languages that Ruby lacks. In a pure functional language, functions may never have side-effects. Ruby functions don't enforce purity, which means it's easier to record program state (e.g., by setting a variable) and easier to change the environment (e.g., by writing a file to disk).

So, in short, Ruby is not a functional programming language (because it is impure), but it does allow programs to be written in a functional style.


## Ruby Closures

In Ruby, a function can be declared using `lambda` syntax:

```ruby
doubler = lambda { |x| x * 2 }
```

A function can also be declared using the following more concise syntax:

```ruby
doubler = ->(x) { x * 2 }
```

Once a function has been declared, it can be invoked by sending the `call` or `[]` messages:

```ruby
doubler.call(3) # => 6
doubler.call(4) # => 8
doubler[5] # => 10
```

Q1. Write a function called `taxrate` that takes a single numeric argument, called `gross`. If `gross` is less than or equal to 10,000 then `taxrate` should return 0. Otherwise, `taxrate` should return `0.2`.

### Closures

Strictly speaking, Ruby functions are actually *closures* because they capture any variables in the current local scope:

```ruby
def create_multiplier(factor)
  ->(x) { x * factor }
end

doubler = create_multiplier(2)
tripler = create_multiplier(3)

doubler.call(4) # => 8
tripler.call(4) # => 12
```

Here, the crucial detail is that `factor` isn't defined inside the lambda expression. Rather, when the lambda expression is evaluated, the Ruby interpreter captures the current value of the `factor` variable and stores that alongside the lambda. This is a closure: a more general notion than a bare function. A closure is the combination of a function and a binding of any free variables to values. In other words, `doubler` and `tripler` are both closures. They share the same underlying function (lambda expression), but have a different binding of free variables: `doubler` has the binding `factor => 2`, whereas `tripler` has the binding `factor => 3`.

Q2. Write a Ruby method called `create_taxrate` that takes two numeric arguments, `allowance` and `basic_rate`.  The `create_taxrate` method should return a lambda expression that returns `0` if its single numeric argument is less than `allowance` and returns `basic_rate` otherwise. Use `create_taxrate` to define functions that represent a few different taxation systems.

### Blocks

You will have already encountered Ruby code that looks something like this:

```ruby
%w(Fred Wilma Pebbles Dino).each do |first_name|
  puts "Hello #{first_name} Flintstone"
end
```

Or perhaps:

```ruby
%w(Fred Wilma Pebbles Dino).each { |first_name| puts "#{first_name} Flintstone" }
```

What is going on here? The `do...end` or `{ ... }` syntax that can be used when sending a message to an object is a special form of closure, called a block.

Blocks seem a little magical at first, but they are just lambdas that are declared using a special syntax. We'll see why that special syntax is useful in a moment, but first let's see how to write a method that takes a block argument:

```ruby
def greet_flintstones(&greeter)
  greeter.call("Fred")
  greeter.call("Wilma")
  greeter.call("Pebbles")
end

greet_flintstones { |first_name| puts "Hello #{first_name}" }
greet_flintstones { |first_name| puts "Oh look, it's #{first_name}" }
```

Note that the `greeter` argument is prefixed with `&` -- this indicates that the argument must be a block.

Blocks are so commonly used in Ruby that there are a couple of syntactic shortcuts. We can rewrite `greet_flintstones` as follows:

```ruby
def greet_flintstones
  yield "Fred"
  yield "Wilma"
  yield "Pebbles"
end
```

There are two important things to note here. Firstly, all Ruby methods can accept a block argument even if no block parameter has been declared. Secondly, the `yield` keyword is used to send the `call` message to any block argument. (Note that the `block_given?` message -- not shown here -- can be sent from any method to determine whether or not a block has been passed to the current method invocation, and hence whether or not it is safe to call `yield`).

Q3. Write a method `calculate_tax` that accepts two arguments: a number `gross`, and a single block argument. The block argument should, given a number, return a tax rate to apply to that figure. The `calculate_tax` method should return the result of applying the tax rate to the `gross`. Some test cases are:

* calculate_tax(10000) { |gross| 0.2 } # should return 2000
* calculate_tax(10000) { |gross| if gross <= 10000 then 0 else 0.2 end } # should return 0
* calculate_tax(15000) { |gross| if gross <= 10000 then 0 else 0.2 end } # should return 3000


Finally, let's take a quick look at why the concise block syntax can be preferable to using bare lambdas. Consider again this code:

```ruby
def greet_flintstones
  yield "Fred"
  yield "Wilma"
  yield "Pebbles"
end

greet_flintstones { |first_name| puts "Oh look, it's #{first_name}" }
```

If Ruby had only lambdas and no blocks, we'd instead need to rewrite the above as:

```ruby
def greet_flintstones(greeter)
  greeter.call("Fred")
  greeter.call("Wilma")
  greeter.call("Pebbles")
end

greet_flintstones(->(first_name) { puts "Oh look, it's #{first_name}" })
```

Notice how sending the `greet_flinstones` message is now syntactically tricky: there's three different sets of brackets, for starters. This is why Ruby's block syntax exists.

### Converting symbols to blocks

We've already seen the use of `&` to denote that a parameter is a block. There's another use of `&` which is particularly handy: it can be used to convert a symbol into a block:

```ruby
fooer = &:foo # => this won't parse (because blocks can't be assigned) but it's roughly equivalent to:
fooer = ->(x) { x.foo }
```

When we would ever need to do this?! Well, it's pretty handy when we want to send a message that includes a very simple block:

```ruby
names = %w(Fred Wilma Pebbles Dino).each(&:upcase!) # => %w(FRED WILMA PEBBLES DINO)

# which is equivalent to:

names = %w(Fred Wilma Pebbles Dino).each { |name| name.upcase! }
```

This style is very popular when used in conjunction with the methods from the Enumerable module, as we shall soon see.


## Functional Ruby via Enumerable

The Enumerable module is one of the most useful parts of the Ruby library. Enumerable captures logic for filtering, searching, and processing collections. Array and Hash both include Enumerable (i.e., they inherit all of Enumerable's methods), as do many other data structures in third-party Ruby software packages. This section will briefly introduce a few of the most useful methods on Enumerable.

### Iterating

We've already seen `each` which takes a block, and applies that block to each element in the collection:

```ruby
%w(Fred Wilma Pebbles Dino).each do |first_name|
  puts "Hello #{first_name}"
end

# =>
# Hello Fred.
# Hello Wilma.
# Hello Pebbles.
# Hello Dino.

```

As you may now expect, `each` is defined on Enumerable (and not on Array). Enumerable also defines a number of other useful iteration methods...

The first -- `each_with_index` -- behaves like each, but yields two arguments to its block: the first argument is the current element in the collection, and the second argument is the index of the current element:

```ruby
%w(Fred Wilma Pebbles Dino).each_with_index do |first_name, index|
  puts "Hello #{first_name}. You appear at index #{index} in the array."
end

# =>
# Hello Fred. You appear at index 0 in the array.
# Hello Wilma. You appear at index 1 in the array.
# Hello Pebbles. You appear at index 2 in the array.
# Hello Dino. You appear at index 3 in the array.
```

The second and third -- `each_slice(n)` and `each_cons(n)` -- behave like each, but yield an array of size n to their block. `each_slice` iterates in steps of size n, whereas `each_cons` iterates in steps of size 1 (consecutive elements):

```ruby
%w(Fred Wilma Pebbles Dino).each_slice(2) do |pair|
  puts "The current pair is #{pair}"
end

# =>
# The current pair is ["Fred", "Wilma"]
# The current pair is ["Pebbles", "Dino"]
```

```ruby
%w(Fred Wilma Pebbles Dino).each_cons(2) do |pair|
  puts "The current pair is #{pair}"
end

# =>
# The current pair is ["Fred", "Wilma"]
# The current pair is ["Wilma", "Pebbles"]
# The current pair is ["Pebbles", "Dino"]
```

Q4. Use Enumerable method(s) to implement the "sliding window minimum" algorithm. The algorithm takes a list of n numbers and a window size of k, and returns a list of minimum values in each of the n-k+1 successive windows. For example, given the list `[4, 3, 2, 1, 5, 7, 6, 8, 9]` and a window of size 3, the desired output is the list `[2, 1, 1, 1, 5, 6, 6]`

### Querying

Enumerable provides universal and existential quantification via its `all?` and `any?` methods:

```ruby
%w(Fred Wilma Pebbles Dino).all? { |name| name.size >= 4 }  # true
%w(Fred Wilma Pebbles Dino).all? { |name| name.size >= 5 }  # false

%w(Fred Wilma Pebbles Dino).any? { |name| name.size >= 5 }  # true
%w(Fred Wilma Pebbles Dino).any? { |name| name.size >= 8 }  # false
```

It also provides the `one?` and `none?` methods, which check that exactly one or exactly no elements match a condition:

```ruby
%w(Fred Wilma Pebbles Dino).one? { |name| name.size == 4 }  # false
%w(Fred Wilma Pebbles Dino).one? { |name| name.size == 5 }  # true

%w(Fred Wilma Pebbles Dino).none? { |name| name.size == 5 }  # false
%w(Fred Wilma Pebbles Dino).none? { |name| name.size == 8 }  # true
```

#### Finding and filtering

Enumerable makes it easy to search the underlying collection. You will have already encountered `include?`:

```ruby
%w(Fred Wilma Pebbles Dino).include?("Fred")   # => true
%w(Fred Wilma Pebbles Dino).include?("Barney") # => false
```

It's also possible to find the first element of an enumerable which matches some condition via `detect`:

```ruby
%w(Fred Wilma Pebbles Dino).detect { |name| name.start_with?("P") }  # => Pebbles
%w(Fred Wilma Pebbles Dino).detect { |name| name.include?("i") }     # => Wilma
%w(Fred Wilma Pebbles Dino).detect { |name| name.include?("q") }     # => nil
```

To filter a collection (rather than find a single element), use `select`:

```ruby
%w(Fred Wilma Pebbles Dino).select { |name| name.include?("i") }  # => ["Wilma", "Dino"]
%w(Fred Wilma Pebbles Dino).select { |name| name.include?("q") }  # => []
```

The opposite of `select` is `reject`:

```ruby
%w(Fred Wilma Pebbles Dino).reject { |name| name.include?("i") }  # => ["Fred", "Pebbles"]
%w(Fred Wilma Pebbles Dino).reject { |name| name.include?("q") }  # => ["Fred", "Wilma", "Pebbles", "Dino"]
```

Q5. Suppose that Enumerable#select did not exist. How would you implement it? (You may assume that you can call `each`).

### Processing

Enumerable also provides many methods that can be used to process collections. Let's take a look at some of the most useful.

The `map` method applies its block to every element in the collection, returning the resultant collection:

```ruby
%w(Fred Wilma Pebbles Dino).map { |name| name.size }  # => [4, 5, 7, 4]
```

It's sometimes useful to combine two or more data structures into a single structure. Enumerable provides `zip` for this purpose:

```ruby
%w(Fred Wilma Pebbles Dino).zip(%w(Barney Betty Bamm-Bamm)) # => [["Fred", "Barney"], ["Wilma", "Betty"], ["Pebbles", "Bamm-Bamm"], ["Dino", nil]]
```

Note that the result of zip is, in this case, an array of arrays.

Probably the most powerful (but most confusing) method provided by Enumerable is `inject`. Inject is used to perform a cumulative calculation over a collection:

```ruby
# Find the longest name:
%w(Fred Wilma Pebbles Dino).inject do |result, current_element|
  if result.size > current_element.size
    result
  else
    current_element
  end
end
```

The key to understanding `inject` is to notice that the return value of the block is used as the first argument to the next execution of the block. In the code above, for example, the first execution of the block returns `"Fred"` which becomes the value of `result` in the second execution of the block.

Q6. Revisit your answer to the question "Write a Ruby program that, given a string, returns all of the substrings of that string" (from the first part of this tutorial). How might you use some of the methods on Enumerable to solve the problem with less code?

### Laziness (Ruby 2.0 onwards)

Note that lazy evaluation will not work on Ruby 1.9 (which is the version installed by default in the CS student labs).

Enumerable also supports lazy iteration, which allows code to be written that is efficient when operating on large collections.

Suppose, for example, we want to find all square numbers which are under 100. The following code is correct, but will take a *very* long time to run, because Ruby will apply `map` and `select` to every element in the collection.

```ruby
(1..Float::INFINITY).map { |n| n ** 2 }.select { |n| n < 100 }
```

A lazy collection will instead only apply Enumerable methods as they are needed:

```ruby
values = (1..Float::INFINITY).lazy.map { |n| n ** 2 }.select { |n| n < 100 }  # returns instantly
values.first        # => 1
values.take(9).to_a # => [1, 4, 9, 16, 25, 36, 49, 64, 81]
```

If you'd like to know more about how laziness is implemented in Ruby, take a look at the Enumerator module (note: this is different to Enumerable module). For example, try [Episode 59 of Ruby Tapas](https://www.youtube.com/watch?v=wsE_srLBCeA).
