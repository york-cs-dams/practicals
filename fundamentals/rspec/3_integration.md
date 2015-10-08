# An RSpec tutorial, part 3

This three-part tutorial introduces RSpec, one of the most popular (unit) testing frameworks for Ruby.

This third part covers how to apply RSpec to perform integration ("or end-to-end") testing. This style of testing allows us to check whether the various units (e.g., classes) are working together correctly.

The [first part](1_basics.md) of this tutorial covered writing your first RSpec tests, and the [second part](2_doubles.md) covered test doubles.

*Note that this tutorial will not work with the Ruby installation on the CS student lab machines. You can instead use the Vagrant setup for DAMS practicals as discussed in at the end of the [Vagrant tutorial](../tools/vagrant.md).*


## Integration testing

Integration tests are high-level tests that are meant to check whether entire pieces of functionality in an application are working correctly. Integration tests normally drive the application via its external interface, such as its graphical-user interface. For example, an integration test might check whether we can log in to an application via its webpages.

Integration tests are complementary to unit tests: we typically need both. Integration tests are more likely to be understandable to the product owner than unit tests. Unit tests are more likely to be useful to developers when designing and maintaining an application than integration tests.


## Integration testing in RSpec

In terms of syntax, an RSpec integration test is very similar to a unit test:

```ruby
feature "Sign in" do
  scenario "works for a valid username and password" do
    # ...
  end
end
```

Note that we use `feature` rather than `describe` and `scenario` rather than `it`. But otherwise, the structure of an integration test is very similar to that of a unit test.

A more important difference, however, is that an integration test uses some mechanism for driving the application via its external interface. For example, if we developing a command-line application, our integration tests would use a Ruby library or language construct for issuing shell commands. On the other hand, if we were developing a web application, our integration tests would drive a (fake) web browser. The rest of this tutorial is concerned with the latter: integration testing web applications.


## Integration testing of web applications with RSpec and Capybara

There are several mechanisms for integration testing a web application with RSpec, including via [Capybara](https://github.com/jnicklas/capybara) gem. Capybara simulates how a real user would interact with your web application.

Let's first take a look at some code that uses Capybara:

```ruby
feature "Sign in" do
  scenario "works for a valid username and password" do
    visit('/signin')
    fill_in('Name', with: 'Joe Bloggs')
    fill_in('Email', with: 'joe@bloggs.com')
    click_on('Sign In')

    expect(page).to have_content('Hello, Joe Bloggs!')
  end
end
```

Capybara provides two sets of useful methods that can be used in RSpec integration tests, *commands* and *matchers*. The commands can be used to simulate a real user visiting our web application in their browser. The test above simulates a user who has:

* Visited the '/signin' page of our web application
* Filled in the value 'Joe Bloggs' into a text field named 'Name'
* Filled in the value 'joe@bloggs.com' into a text field named 'Email'
* Clicked on a button named 'Sign In'

There are many more Capybara commands in addition to `visit`, `fill_in`, and `click_on`: see the [Capybara documentation on 'the DSL'](https://github.com/jnicklas/capybara#the-dsl) for a brief overview and links to complete lists.

Commands are used to setup some state in the web application, and then matchers can be used to make assertions about the current web page. For example, the integration test above will pass only if the current page contains the text "Hello, Joe Bloggs!" somewhere. Some useful Capybara matchers are:

* `expect(page).to have_content(text)` - passes only if the current page contains `text`
* `expect(page).to have_link(title)` - passes only if the current page contains a link named `title`
* `expect(page).to have_link(title, href: target)` - passes only if the current page contains a link named `title` which links to the `target` page
* `expect(current_path).to eq(address)` - passes only if the (fake) web browser is currently at `address`

There are plenty more Capybara matchers: see the [Capybara documentation on querying](https://github.com/jnicklas/capybara#querying) for a brief overview and a link to a complete list.


Q1. Take a look at Flippd's integration tests, starting with those for the [phase](https://github.com/flippd/flippd/blob/master/spec/features/phase_spec.rb) and [video](https://github.com/flippd/flippd/blob/master/spec/features/video_spec.rb) pages. Replicate each of these tests by navigating through the application manually, following the Capybara commands. Which of these tests should pass?

Q2. Suppose Flippd was to be extended such that if a user watched a video to the end, the video page would then display a "watched" label when that user visited the page again in the future. Write down, in plain English, two or three test cases for this functionality.

Q3. Translate your plain English test cases from Q2 to RSpec integration tests that use Capybara. (You may assume that there is a Capybara command called `watch_video` which will simulate playing a video until the end, if we are currently `visit`ing the page for that video).
