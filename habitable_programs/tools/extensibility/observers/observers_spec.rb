require_relative "observers"

describe Table do
  let(:logger) { spy }
  let(:party) { Party.new(4) }
  subject { Table.new(party, logger) }

  context "notifies the kitchen" do
    let(:kitchen) { spy("kitchen") }

    before(:each) do
    # TODO: something like this:
    #  subject.add_observer(kitchen)
    end

    it "when ordering food" do
      subject.order_food
      expect(kitchen).to have_received(:order_up).with(subject)
    end

    xit "when eating starter" do
      subject.eat_starter
      expect(kitchen).to have_received(:ready_for_main).with(subject)
    end

    xit "when eating main" do
      subject.eat_main_course
      expect(kitchen).to have_received(:ready_for_dessert).with(subject)
    end

    xit "of everything when dining" do
      subject.dine
      expect(kitchen).to have_received(:order_up).with(subject)
      expect(kitchen).to have_received(:ready_for_main).with(subject)
      expect(kitchen).to have_received(:ready_for_dessert).with(subject)
    end
  end

  xcontext "notifies the maitre d'hotel" do
    let(:maitre_d_hotel) { spy("maitre_d_hotel") }

    before(:each) do
    # TODO: something like this:
    #  subject.add_observer(maitre_d_hotel)
    end

    it "when ordering drinks" do
      subject.order_drinks
      expect(maitre_d_hotel).to have_received(:table_occupied).with(number_of_people: 4)
    end

    xit "when paying the bill" do
      subject.pay_the_bill
      expect(maitre_d_hotel).to have_received(:table_free).with(number_of_people: 4)
    end

    xit "of everything when dining" do
      subject.dine
      expect(maitre_d_hotel).to have_received(:table_occupied).with(number_of_people: 4)
      expect(maitre_d_hotel).to have_received(:table_free).with(number_of_people: 4)
    end
  end

  xcontext "notifies the manager" do
    let(:manager) { spy("manager") }

    before(:each) do
    # TODO: something like this:
    #  subject.add_observer(manager)
    end

    it "when revenue increases" do
      subject.pay_the_bill
      expect(manager).to have_received(:cha_ching).with(bill: 0)
    end
  end
end
