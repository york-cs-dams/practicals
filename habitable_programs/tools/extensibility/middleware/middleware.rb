class Logger
  def log(message)
    puts message
  end
end

class Restaurant
  attr_reader :logger

  def initialize(logger: Logger.new)
    @logger = logger
  end

  def process_order(order)
    fail "What do you think this is, a salad bar?! Order some pizzas!" if order.pizzas.empty?
    order.discount = 5 if order.pizzas.size >= 3
    order.sides = %i(onion_rings) if order.total >= 15
    logger.log "Sending #{order} to kitchen"
  end
end
