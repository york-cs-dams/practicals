require_relative "subscription"

describe Subscription do
  it "should not create a charge if a payment already exists for this subscription id" do
    payments = double("Payments")
    allow(payments).to receive(:exists).and_return(true)

    subscription = Subscription.new(42, nil, payments)
    subscription.bill(9.99)
  end

  xit "should create a charge if there is no existing payment for this subscription id" do
    payments = double("Payments")
    allow(payments).to receive(:exists).and_return(false)
    expect(payments).to receive(:charge).with(subscription_id: 42, amount: 9.99)

    subscription = Subscription.new(42, nil, payments)
    subscription.bill(9.99)
  end

  it "should create a charge if there is no existing payment for this subscription id (with a spy)" do
    payments = spy("Payments")
    allow(payments).to receive(:exists).and_return(false)

    subscription = Subscription.new(42, nil, payments)
    subscription.bill(9.99)

    expect(payments).to have_received(:charge).with(subscription_id: 42, amount: 9.99)
  end
end
