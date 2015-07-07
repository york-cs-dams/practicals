require_relative "../../lib/subjects/source"

module Subjects
  describe Source do
    describe "common_fragment_with" do
      it "should find first fragment of appropriate length" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new(%w(foo bar))

        expect(subject.common_fragment_with(other, 1)).to eq(%w(foo))
      end

      it "should find first fragment of appropriate length when match occurs in middle of sources" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new(%w(qux bar))

        expect(subject.common_fragment_with(other, 1)).to eq(%w(bar))
      end

      it "should return nil when there is no common fragment" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new(%w(qux))

        expect(subject.common_fragment_with(other, 1)).to be_nil
      end

      it "should find fragments when length is larger than 1" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new(%w(bar baz))

        expect(subject.common_fragment_with(other, 2)).to eq(%w(bar baz))
      end

      it "should return nil when there is no fragment of the appropriate length" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new(%w(baz))

        expect(subject.common_fragment_with(other, 2)).to be_nil
      end
    end


    xdescribe "longest_common_fragment_with" do
      it "should find longest common fragment between two sources" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new(%w(abc bar def bar baz xyz))

        expect(subject.longest_common_fragment_with(other)).to eq(%w(bar baz))
      end

      it "should return empty when there is no longest common fragment" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new(%w(qux))

        expect(subject.longest_common_fragment_with(other)).to eq([])
      end

      it "should return empty when one source is empty" do
        subject = Source.new(%w(foo bar baz))
        other   = Source.new([])

        expect(subject.longest_common_fragment_with(other)).to eq([])
      end
    end
  end
end
