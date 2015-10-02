# An RSpec tutorial, part 2

This three-part tutorial introduces RSpec, one of the most popular (unit) testing frameworks for Ruby.

This second part covers how to apply stubs, mocks and spies to perform isolated unit testing.

The [first part](1_basics.md) of this tutorial covered writing your first RSpec tests, and the [third part](3_integration.md) covers integration testing with RSpec.

*Note that this tutorial will not work with the Ruby installation on the CS student lab machines. You can instead use the Vagrant setup for DAMS practicals as discussed in at the end of the [Vagrant tutorial](../tools/vagrant.md).*

## Stubbing

Suppose that we have the following code (taken from `./subscription/subscription.rb`):

```ruby
class Subscription
  attr_reader :id, :logger, :payments

  def initialize(id, logger, payments)
    @id = id
    @logger = logger
    @payments = payments
  end

  def bill(amount)
    unless payments.exists(subscription_id: id)
      payments.charge(subscription_id: id, amount: amount)
      logger.print "Billed subscription #{id}"
    end
  end
end
```

Let's also suppose that we first wish to test the case where a payment already exists for the current subscription (i.e., the body of the unless block is not executed). You can find this code in `./subscription/subscription_spec.rb`

```ruby
describe Subscription do
  xit "should not create a charge if a payment already exists for this subscription id" do
    # TODO
  end
end
```

 We have two choices: we can create an instance of a real payments gateway (and of a real logging class), and test Subscription along with the payments gateway class (and the logging class). Or, we can use a test double to test Subscription in isolation. If we want our unit tests to be fast, using a test double is the right choice:

 ```ruby
 require_relative "subscription"

 describe Subscription do
   it "should not create a charge if a payment already exists for this subscription id" do
     payments = double("Payments")
     allow(payments).to receive(:exists).and_return(true)

     subscription = Subscription.new(42, nil, payments)
     subscription.bill(9.99)
   end
 end
```

Notice that a test double is created using RSpec's `double` method. RSpec's `allow` method can then be used to specify the messages to which the test double should respond. Try commenting out the line containing the allow statement and run the tests (with `vado rake test:rspec:subscription`).

Q1. Why does the test now fail?

## Mocking

If we now wish to test that Subscription does indeed call `charge` when a payment does not already exist, we again need to use a stub:

```ruby
require_relative "subscription"

describe Subscription do
  it "should create a charge if there is no existing payment for this subscription id" do
    payments = double("Payments")
    allow(payments).to receive(:exists).and_return(false)

    subscription = Subscription.new(42, nil, payments)
    subscription.bill(9.99)
  end
end
```

But we also need to assert that the postconditions of the method have been met: i.e., that a `charge` message has been sent to payments. We can achieve this with a mock. Note the new line containing the expect statement below:

```ruby
require_relative "subscription"

describe Subscription do
  it "should create a charge if there is no existing payment for this subscription id" do
    payments = double("Payments")
    allow(payments).to receive(:exists).and_return(false)
    expect(payments).to receive(:charge).with(subscription_id: 42, amount: 9.99)

    subscription = Subscription.new(42, nil, payments)
    subscription.bill(9.99)
  end
end
```

Q2. If you run this test, you'll notice that it fails with `NoMethodError: print called for NilClass`. What does this mean? How might you use another test double to solve this problem?


## Spying

Some people prefer to see the expectations (assertions) of their tests at the end of the test case. If you are one of these people, you will prefer to use a spy rather than a mock:

```ruby
require_relative "subscription"

describe Subscription do
  it "should create a charge if there is no existing payment for this subscription id (with a spy)" do
    payments = spy("Payments")
    allow(payments).to receive(:exists).and_return(false)

    subscription = Subscription.new(42, nil, payments)
    subscription.bill(9.99)

    expect(payments).to have_received(:charge).with(subscription_id: 42, amount: 9.99)
  end
end
```
