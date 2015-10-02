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
