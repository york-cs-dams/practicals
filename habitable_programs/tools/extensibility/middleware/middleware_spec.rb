require_relative "middleware"

describe Restaurant do
  let(:order) { spy("order") }
  let(:logger) { spy("logger") }
  subject { Restaurant.new(logger: logger) }

  before(:each) do
    allow(order).to receive(:pizzas) { %i(margherita pepperoni margherita) }
  end

  it "(says that it) sends the order to the Kitchen" do
    subject.process_order(order)
    expect(logger).to have_received(:log).with("Sending #{order} to kitchen")
  end

  it "filters out empty orders" do
    allow(order).to receive(:pizzas) { [] }
    expect { subject.process_order(order) }.to raise_error("What do you think this is, a salad bar?! Order some pizzas!")
  end

  it "discounts the order by £5 when there are 3 (or more) pizzas" do
    subject.process_order(order)
    expect(order).to have_received(:discount=).with(5)
  end

  it "adds a free side dish when the order is £15 or more" do
    allow(order).to receive(:total) { 15 }
    subject.process_order(order)
    expect(order).to have_received(:sides=).with(%i(onion_rings))
  end
end
