# A Ruby tutorial, part 2

This three-part tutorial introduces Ruby, object-oriented programming in Ruby, and functional programming in Ruby.

This second part covers object-oriented programming in Ruby, and more specifically:

* How sending messages is integral to Ruby's approach to OOP
* How to define classes and methods in Ruby
* Subtle but important points to consider when implementing Ruby classes including equality, hashing and pretty printing.

The [first part](1_introduction.md) covered installation and the key Ruby data types. The [third part](3_functional.md) covers functional programming in Ruby.

## Object-Oriented Programming in Ruby

Ruby is a pure object-oriented language: every Ruby value is an Object and conforms to some Class. So, unlike Java, primitives are objects:

```ruby
42.is_a? Object  # => true
true.is_a? Object # => true
nil.is_a? Object # => true
```

Like most object-oriented languages, types are properly known as Classes. Every object has a class, and a class describes a set of characteristics (data and behaviour) that a set of objects share:

```ruby
42.class   # => FixNum
true.class # => TrueClass
nil.class  # => NilClass

42.class == 99.class # => true
```

All Ruby objects respond to a number of useful messages. We've already seen a couple of these (`is_a?` and `class`). Here are some more:

```ruby
42.nil?  # => false
nil.nil? # => true

42.clone # => 42
```

### Sending messages

We can check whether an object responds to a type of message:

```ruby
"Hello".respond_to?(:chars)    # => true
"Hello".respond_to?(:to_float) # => false
```

We can also send a message to an object as shown below.

```ruby
"Hello".send(:chars)          # => ["H", "e", "l", "l", "o"]
"Hello".send(:gsub, "l", "*") # = "He**o"
```

Using Object#send is very much like using dot notation (as shown below), but `send` can be used to send messages that are normally private. (This will make more sense after we discuss private and protected scopes...)

```ruby
"Hello".chars
"Hello".gsub("l", "*")
```

In many OO languages we think of "invoking a method" rather than "sending a message". This is a reasonable approximation for what happens in Ruby, but is not the whole truth: as we shall see later Ruby objects need not only define methods in order to respond to messages.


### Using Ruby classes

So far, we've mostly used literals to create Ruby objects. We can also send the `new` message to an instance of Class in order to create an object:

```ruby
String.new # => ""
Array.new  # => []
Hash.new   # => {}
```

To create our own classes, we can send the `new` message to the Class class:

```ruby
Person = Class.new
bob = Person.new  # => <Person:0x007f8d36083368>
```

The Class class responds to a number of useful messages, including those for specifying how instances should respond to messages:

```ruby
Person = Class.new do
  define_method(:greet) do
    "Hello!"
  end

  define_method(:drive) do |vehicle|
    vehicle.start
    while true
      vehicle.steer
      vehicle.accelerate
    end
  end
end

bob = Person.new
bob.greet # => "Hello!"
```

Of course, this syntax is quite cumbersome, so Ruby defines some syntactic sugar:

```ruby
class Person
  def greet
    "Hello!"
  end

  def drive(vehicle)
    vehicle.start
    while true
      vehicle.steer
      vehicle.accelerate
    end
  end
end
```

In case you were wondering: yes, the Class class is an Object...

```ruby
Class.is_a? Object # => true
```

If that doesn't hurt your brain, you've not thought about it hard enough!

#### Defining methods

Methods are a crucial part of object-oriented programming: they specify how a class of objects respond to a message.

In Ruby, methods implicitly return the value of their last expression:

```ruby
def meaning_of_life
  42
end

def two_and_two
  2 + 2
end

def twelve_hour_time_suffix
  if morning?
    "a.m."
  else
    "p.m."
  end
end
```

The `return` keyword can be used to return an explicit value early:

```ruby
def two_and_two
  return 5 if speculating?
  2 + 2
end
```

Methods can specify parameters:

```ruby
class Circle
  def area(radius)
    Math::PI * radius ** 2
  end
end

Circle.new.area(5) # => 78.53981633974483
```

Parameters can have default values:

```ruby
class Rectangle
  def area(width = 10, height = width)
    width * height
  end
end

r = Rectangle.new
r.area       # => 100
r.area(4)    # => 16
r.area(4, 5) # => 20
```

The "splat" operator `*` can be used to define methods with a variable number of arguments:

```ruby
class Line
  def add_segment(*points)
    # ...
    # NB: points is an array
  end
end

l = Line.new
l.add_segment(1, 2, 3)
l.add_segment
l.add_segment(4, 5)
l.add_segment(6)
```


From Ruby 2.1, parameters can be defined by keyword rather than positionally, as shown below.

*Note that the keyword arguments -- and hence the following code -- will not work on Ruby 1.9, which is the version installed by default in the CS student labs. You can instead use Ruby via Vagrant as discussed in the [Vagrant video](http://dams.flippd.it/videos/7) and [tutorial](../tools/vagrant.md).*

```ruby
class Circle
  def area(radius:)
    Math::PI * radius ** 2
  end
end

class Rectangle
  def area(width: 10, height: width)
    width * height
  end
end


Circle.new.area(radius: 5) # => 78.53981633974483

r = Rectangle.new
r.area                      # => 100
r.area(width: 4)            # => 16
r.area(width: 4, height: 5) # => 20
r.area(height: 5)           # => 50
```

The "double splat" operator `**` can be used to define methods with a variable number of **keyword** arguments:

```ruby
class Rectangle
  def area(width: 10, height: width, **options)
    # ...
    # NB: options is a hash
    width * height
  end
end
```

Finally, a Ruby method can take a block (piece of code), as discussed in [the final part of this tutorial](./3_functional.md).

#### Constructors, instance variables and accessors

Classes can define constructors, which are used when responding to the new message:

```ruby
class Person
  def initialize(forename, surname)
    conn = Database.connect
    conn.run("INSERT INTO people(name) VALUES \"#{forename} #{surname}\";")
  end
end

Person.new("Alice", "Smith")
```

Writing to a database is a contrived (and pretty moronic!) way to use a constructor. More commonly, constructors are used to set instances variables:

```ruby
class Person
  def initialize(forename, surname)
    @fullname = "#{forename} #{surname}"
  end

  def greeting
    "Hello, #{@fullname}"
  end
end

p = Person.new("Alice", "Smith")
p.greeting # => "Hello, Alice Smith"
```

Accessor messages (getters and setters) are conventionally named `var` and `var=` in Ruby (rather than, say, `getVar()` and `setVar()` in Java):

```ruby
class Person
  def initialize(forename, surname)
    @forename, @surname = forename, surname
    @fullname = "#{forename} #{surname}"
  end

  def forename
    @forename
  end

  def forename=(new_forename)
    @forename = new_forename
  end

  def surname
    @surname
  end

  def surname=(new_surname)
    @surname = new_surname
  end

  def greeting
    "Hello, #{@fullname}"
  end
end
```

Providing getters and setters is such a common OO pattern that Ruby provides a syntactic shortcut:

```ruby
class Person
  attr_accessor :forename, :surname

  def initialize(forename, surname)
    @forename, @surname = forename, surname
    @fullname = "#{forename} #{surname}"
  end

  def greeting
    "Hello, #{@fullname}"
  end
```

Q1. What do the `attr_reader` and `attr_writer` messages do? Hint: they are defined on the Module class.

When a class can be structured such that its constructor only assigns parameters to instance variables, a Struct can be used to make the code even more concise.

```ruby
Person = Struct.new(:forename, :surname) do
  def fullname
    "#{forename} #{surname}"
  end

  def greeting
    "Hello, #{fullname}"
  end
end
```

Q2. When might you use a Struct instead of a Hash? When might you use a Hash instead of a Struct?

#### Equality

Most programming languages support several different types of equality, and Ruby is no different. There are four types of equality in Ruby. Let's start by looking at the first three types of equality:

1. `a == b` (generic equality) true iff `a` and `b` are the same according to the class of `a`
2. `a.eql?(b)` (hash equality): true iff `a` and `b` are `==` and are of the same type.
3. `a.equal?(b)` (identity equality): true iff `a` and `b` are the same object.

The third type of equality is essentially pointer comparison. It's very, very rare to override this when defining a new class. By contrast, it is often useful to override the first type of equality (`==`) to provide an implementation that makes sense for that specific class of objects:

```ruby
class Money
  attr_accessor :pounds, :pence

  def ==(other)
    other.pounds == pounds && other.pence == pence
  end
end
```

Here the Money class specifies that two instances are the same when they have the same `pounds` and `pence` attributes.

For most classes, the distinction between `eql?` and `==` is unimportant. In which case, it's often useful if `eql?` has the same implementation as `==`. There is a shorthand for this in Ruby:

```ruby
class Money
  attr_accessor :pounds, :pence

  def ==(other)
    other.pounds == pounds && other.pence == pence
  end

  alias_method :eql?, :==
end
```

It's normally only useful to have different implementations for `eql?` and `==` when defining several classes that have a shared notion of equality. In this case, `==` returns true when two instances are equivalent, and `eql?` returns true when two instances are equivalent and of the same type:

```ruby
class Sterling
  attr_accessor :pounds, :pence

  def eql?(other)
    other.pounds == pounds && other.pence == pence
  end

  def ==(other)
    eql?(other.to_sterling)
  end

  def to_sterling
    self
  end
end

class USD
  attr_accessor :dollars, :cents

  def eql?(other)
    other.dollars == dollars && other.cents == cents
  end

  def ==(other)
    eql?(other.to_sterling)
  end  

  def to_sterling
    # use an external service to convert self from USD to GBP
  end
end
```

The fourth and final type of equality in Ruby is `===` (case equality). This is used to specify how instances of a class should be compared within a `case` statement. It's quite rare to need to override `===`, but it can be occasionally be used to encode some very elegant solutions. For example, several of Ruby's built-in types have implementations of `===` and hence these types can be used concisely in a `case` statement:

```ruby
case some_object
when 2..4
  # some_object is in the range 2..4
when /a regex/
  # the regex matches some_object
when lambda { |student| student.average_grade > 50 }
  # the lambda returned true when applied to some_object
end
```

Q3. Consider the scenario of event ticketing (e.g., for a sports match, a concert, etc.). Design and implement one (or more) classes for an ordering system. Implement your own equality methods (i.e., override `==` and `eql?`). Try to come up with one situation in which it makes sense to for `eql?` to have a different implementation to `==`.

#### Hashing

Every Ruby object responds to the `hash` message, which requests a numerical identifier for an object. The `hash` message is mostly used internally by Ruby to, for example, arrange the elements of objects inside our data structures, such as Arrays. For our purposes, we only need to know that we **must override hash whenever we override eql?**, as shown below. NB: that the `hash` message has very little to do with the `Hash` type. The former is a message that Ruby sends when we need to *efficiently* determine whether two objects are the same, and the latter is a type that implements an "associative array" (or "dictionary") data structure.

```ruby
class Money
  attr_accessor :pounds, :pence

  def ==(other)
    other.pounds == pounds && other.pence == pence
  end

  alias_method :eql?, :==

  def hash
    pounds.hash + pence.hash
  end
end
```

An implementation of `hash` can normally be very straightforward: send the `hash` message to any attributes used by `eql?` and combine the resulting identifiers. A simple addition or multiplication is normally sufficient (though more complicated solutions are sometimes necessary to improve performance).

Q4. Extend your solution to the event ticketing problem to include appropriate implementations of `hash` for your new classes.

Q5. Temporarily comment out your implementations of `hash`. Can you cause Ruby's Hash type (e.g., `{}`) to behave incorrectly when instances of one of your classes are used as keys? Does your implementation of `hash` fix this problem?

#### Pretty printing

When defining a class, it's often useful to override `to_s` to provide a more user-friendly string representation of instances of that class:


```ruby
class Money
  attr_accessor :pounds, :pence

  def to_s
    "$" + pounds.to_s + "." + pence.to_s
  end
end
```

Note that `puts` and String interpolation call `to_s` for us:

```ruby
m1 = Money.new
m1.pounds, m1.pence = 5, 10
puts m1 # => $5.10
"I have #{m1} in my current account" # => "I have $5.10 in my current account"
```

Q6. Extend your solution to the event ticketing problem to include appropriate implementations of `to_s` for your new classes.

### Class Specialisation

Ruby provides two mechanisms for specialising classes to provide more focussed behaviour, inheritance and mix-ins. Let's look at each of these in turn.

#### Inheritance

Inheritance in Ruby is achieved using the `<` operator when defining a new class:

```ruby
class Salesperson < Person
  attr_reader :sales_target

  def initialize(forename, surname, sales_target)
    super(forename, surname)
    @sales_target = sales_target
  end
end
```

Note that methods can call the superclass's implementation of that method by using the `super` keyword. If you need to call a method in a superclass and pass no arguments, be sure to use the form `super()` and not `super` because the latter is a syntactic shortcut that automatically passes all arguments.

#### Mix-ins via Ruby Modules

Mix-ins are intended for reusing small pieces of functionality that make sense for many of the types in a Ruby program. They should probably have been called traits.

A mix-in is achieved by first defining a Ruby module, as shown below. A Ruby module is like a class, but cannot be instantiated:

```ruby
module Likeable
  def likes
    @likes ||= 0
  end

  def like!
    @likes = likes + 1
  end
end
```

And then including that module into a class:

```ruby
class Lecturer
  include Likeable
  attr_reader :name

  def initialize(name)
    @name = name
  end
end
```

Including a module is as if the methods had been implemented directly on the including class:

```ruby
louis = Lecturer.new("Louis")
louis.like!
louis.like!
louis.likes # => 2
```

Q7. Ruby provides some useful built-in modules. What does the Comparable module? How might you use it for event ticketing?

### Namespacing

We're already seen one use for Ruby modules: defining mix-ins. There are also quite often used to provide namespaces. This allows more than one class with the same name to reside in the same Ruby program:

```ruby
module MyAwesomeApp
  module Ancestry
    class Tree
      ...
    end
  end
end

module MyAwesomeApp
  module DataStructures
    class Tree
      ...
    end
  end
end
```

A double colon is used as a separator when referring to namespaced modules:

```ruby
tree = MyAwesomeApp::DataStructures::Tree.new
```

Relative namespaces can be used when within a module:

```ruby
module MyAwesomeApp
  tree = DataStructures::Tree.new
end
```

The top-level namespace can be accessed by prefixing a name with a double colon:

```ruby
module MyAwesomeApp
  module Ancestry
    class Tree
      def upload
        ::Amazon::S3.store(self.to_json)
      end
    end
  end
end
```

That's it for the second part of this Ruby tutorial. Move on to the [third part](3_functional.md) to learn about functional programming in Ruby.
