require_relative "../lib/marking_system"

describe MarkingSystem do
  before(:each) do
    York::StudentInfo.reset
  end

  it "should record marks for a new module" do
    subject.add_marks("DAMS", "2015", alice: 81, bob: 72, clive: 38, daphne: 56)
    marks = subject.summarise_marks("DAMS", "2015")

    expect(marks).to eq "alice: 81\nbob: 72\nclive: 38\ndaphne: 56"
  end

  it "should list no marks for an unknown module and assessment" do
    marks = subject.summarise_marks("DAMS", "2015")
    expect(marks).to eq ""
  end

  it "should raise an error when recording marks twice for the same assessment" do
    subject.add_marks("DAMS", "2015", alice: 81, bob: 72, clive: 38, daphne: 56)
    expect { subject.add_marks("DAMS", "2015", alice: 85) }.to raise_error
  end
end
