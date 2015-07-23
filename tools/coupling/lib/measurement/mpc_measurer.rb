require_relative "../../../common/lib/measurement/measurer"
require_relative "../../../common/lib/locator/method_locator"

module Measurement
  class MPCMeasurer < Measurer
    def locator
      Locator::MethodLocator.new
    end

    def measurements_for(method)
      messages = messages_for(method)

      total = messages.size
      to_self = 0
      to_ancestors = 0
      mpc = total - (to_self + to_ancestors)

      {
        total_messages_passed: total,
        messages_passed_to_self: to_self,
        messages_passed_to_ancestors: to_ancestors,
        mpc: mpc
      }
    end

    def messages_for(method)
      finder = MessageFinder.new
      finder.process(method.ast)
      finder.messages
    end
  end

  class MessageFinder < Parser::AST::Processor
    attr_reader :count

    def on_send(ast)
      super
      messages << ast
    end

    def messages
      @messages ||= []
    end
  end
end
