class Logger
  def log(message)
    puts message
  end
end

class Party
  attr_reader :number_of_people, :bill

  def initialize(number_of_people, bill = 0)
    @number_of_people = number_of_people
    @bill = bill
  end
end

class Table
  attr_reader :party, :logger

  def initialize(party, logger = Logger.new)
    @party = party
    @logger = logger
  end

  def dine
    order_drinks
    order_food
    eat_starter
    eat_main_course
    eat_dessert
    pay_the_bill
  end

  # If the following is unclear, see the Ruby docs for Class#define_method
  %i(order_drinks order_food eat_starter eat_main_course eat_dessert pay_the_bill).each do |stage|
    define_method(stage) do
      logger.log "We're about to #{stage.to_s.tr("_", " ")}"
    end
  end
end



