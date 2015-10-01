# A Ruby tutorial, part 1

This three-part tutorial introduces Ruby, object-oriented programming in Ruby, and functional programming in Ruby.

This first part covers:

* How to install and use the Ruby programming language
* The key data types of Ruby including strings, symbols, arrays and hashes

The [second part](2_object_oriented.md) covers object-oriented programming in Ruby, and the [third part](3_functional.md) functional programming in Ruby.

## Ruby Basics

Most modern operating systems include a reasonably new version of Ruby by default. On Windows, Ruby can be installed via the imaginatively named [RubyInstaller](http://rubyinstaller.org).

The code in this tutorial is intended to work with Ruby 1.9 or newer. If that's not the case, please let me know! You can check your Ruby version like this:

```
$ ruby --version
ruby 2.0.0p481 (2014-05-08 revision 45883) [universal.x86_64-darwin14]
```

If you need to install a newer version of Ruby, I recommend using [RubyInstaller](http://rubyinstaller.org) on Windows or [ruby-install](https://github.com/postmodern/ruby-install#readme) on Linux / OS X.

(Later in DAMS, I will assume that you are using Ruby 2.0 or newer, so consider this if you are installing Ruby on your own machine. If you are using a software lab machine, the Vagrant practical describes how to use Ruby 2.0 or newer).


### Your first Ruby program

Open your favourite text editor, and create a file called hello.rb containing:

```ruby
puts "Hello, world!"
```

Run your program, like so:

```
$ ruby hello.rb
Hello, world!
```

You can also run code directly with the `ruby` command:

```
$ ruby -e 'puts "Hello, world!"'
Hello, world!
```

Yet another way to run Ruby code is via `irb`, the interactive ruby shell:

```
$ irb
irb(main):001:0> puts "Hello, world"
Hello, world
=> nil
irb(main):002:0> exit
```

## Useful Ruby types

The Ruby core library provides many types. Here we'll review a few of the most commonly used.

### Strings

Ruby's string type is used for representing mutable sequences of characters. The string type responds to many useful messages:

```ruby
puts "Hello, world!".downcase
puts "Hello, world!".reverse
puts "Hello, world!".start_with?("Hello")
puts "Hello, world!".gsub("o", "u")
```

Q1. What do you think each of these Ruby statements will print out? Run them and see if you are correct.

Q2. Take a look at the Ruby documentation for the [String](http://ruby-doc.org/core-2.2.3/String.html#method-i-gsub) class. What is the difference between the `gsub` and `gsub!` methods? What other methods look to be useful?

Ruby strings support interpolation:

```ruby
puts "Two plus two is #{2 + 2}"

title = "Ms"
forename = "Alice"
surname = "Smith"
puts "Hello #{title}. #{forename} #{surname}"
```

Single-quotes can also be used to define strings, but this form does not support interpolation. My advice is to always use double-quoted strings. (There is a long-standing misconception that single-quoted strings are more performant than double-quoted strings in Ruby. Ignore this: it's [probably not true](https://viget.com/extend/just-use-double-quoted-ruby-strings) and if you need really performant code don't use Ruby!)

### Symbols

In addition to its string type, Ruby also has the symbol type, which is use for representing immutable sequences of characters. The distinction between strings and symbols is rarely important, but you will see symbols used fairly often in most Ruby code. (We'll see them later when we look at hashes, for example). The symbol literal starts with a colon:

```ruby
puts :hello
puts :"hello world"
```

The [Symbol](http://ruby-doc.org/core-2.2.3/Symbol.html) class responds to few useful messages:

```ruby
puts :hello.empty?
puts :hello.upcase
puts :hello.to_s
```

Ruby has a few different ways to represent numbers:

```ruby
puts 100.class
puts (100.2).class
puts (100**100).class
```

Q3. According to the Ruby documentation what is the difference between each of these types?

### Booleans and nil

Booleans are specified as you might expect:

```ruby
if true
  puts "Hello, world!"
end
```

They respond to a few useful messages:

```ruby
puts true & true
puts true & false
puts true | false
puts false | false
puts !true
```

To represent an absent or unknown value, Rubyists use nil:

```ruby
current_user = nil
puts current_user
puts current_user.nil?
```

In Ruby `nil` is falsey: it acts like `false` when used as the condition of an if statement:

```ruby
current_user = nil
if current_user
  puts "Hello, you"
else
  puts "Hello, stranger"
end
```

Because `nil` is falsey, you'll sometimes see code like this:

```ruby
current_user = ... # call some method that returns an object or nil
if !!current_user
  puts "Hello, you"
else
  puts "Hello, stranger"
end
```

This isn't very readable, so I hope you never encounter it. If you do, read this code as "if current_user isn't falsey" or "if current_user isn't nil and isn't false". Rather than write the code above, write the following (for now):

```ruby
current_user = ... # call some method that returns an object or nil
if (current_user != nil) & (current_user != false)
  puts "Hello, you"
else
  puts "Hello, stranger"
end
```

Q4. Write a Ruby script that determines whether or not a String is palindromic (spelt the same forwards as backwards). You may find the following program to be useful:

```ruby
# Run me using: ruby palindrome.rb "some string"
input = ARGV[0]
puts input
```

### Arrays and Ranges

Ruby's array type is used to represent a mutable and ordered set of values (a sequence). As you might expect, arrays can contain duplicates.

```ruby
["Hello", "Goodbye", "See you soon"].sort
["Hello", "Goodbye", "See you soon"].size
```

Arrays can contain elements with different types:

```ruby
values = [1, "two", :three, nil, [1, 2, 3]]
values.size
```

Ruby provides a couple of handy syntactic shortcuts for defining arrays of Strings and arrays of Symbols:

```ruby
%w(foo bar baz) # => ["foo", "bar", "baz"]
%i(foo bar baz) # => [:foo, :bar, :baz]
```

Array responds to a huge number of useful messages:

```ruby
values.first
values[0]
values.take(2)
values.flatten
values.compact
```

Q5. What do you think each of statements above will do? Run them and check your predictions.

Q6. Array responds to the `[]` message, but it acts quite differently depending on its arguments. Using the Ruby documentation and `irb`, see how many different ways you can use `[]` to access the data contained in an Array.

Array responds to several messages for changing the contents of the array:

```ruby
values << "four"
values.push("five")
values += ["six", "seven"]
values.unshift("zero")

values.pop
values.shift
values.delete("two")
values.delete_at(3)
```

Array also responds to messages for processing its content. The most intuitive of these messages is `each` which iterates over the array:

```ruby
values.each do |value|
  puts "We got a #{value}."
end
```

When defining an array of numbers, it is often preferable to use Ruby's Range data types:

```ruby
user_satisfaction_scores = 1..10
```

Ranges respond to different messages than Arrays:

```ruby
user_satisfaction_scores.cover? 6  # => true
user_satisfaction_scores.cover? 12 # => false
user_satisfaction_scores.step(2).to_a # => [1, 3, 5, 7, 9]
```

Ranges can be converted to Arrays:

```ruby
user_satisfaction_scores << 11      # => NoMethodError: undefined method `<<' for 1..10:Range
user_satisfaction_scores.to_a << 11 # => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
```

Q7. Write a Ruby program that, given a string, returns all of the substrings of that string.

### Hashes

Ruby's dictionary type is called Hash. It can be used to represent a collection of key-value pairs:

```ruby
{
  :forename => "Alice",
  "age" => 42,
  1234 => Object.new
}
```

Many Ruby Hashes are keyed only using Symbols, in which case the following syntax is preferred:

```ruby
{
  forename: "Alice",
  surname: "Smith",
  age: 42
}
```

Hash responds to a number of useful messages:

```ruby
alice = { forename: "Alice", surname: "Smith", age: 42 }
alice.size

alice[:forename]
alice[:title]
alice.fetch(:title, "Ms.")

alice.key?(:title)
alice.values_at(:forename, :surname)
alice.each_pair {|k,v| puts "#{k} is #{v}" }
alice.merge({ salary: 28000, age: 18 })
```

Q8. Change your answer to your previous question to produce a Hash that contains key-value pairs where the key is an integer and the value is an array of substrings of that size. In other words, the result of running your program on "banana" should be:

```ruby
{
  1 => ["b", "a", "n"],
  2 => ["ba", "an", "na"],
  3 => ["ban", "ana", "nan"],
  4 => ["bana", "anan", "nana"],
  5 => ["banan", "anana"],
  6 => ["banana"]
}
```
