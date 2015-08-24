require_relative "pluggable"

describe Pluggable do
  subject { Class.new.extend(Pluggable) }

  context "complete plugin" do
    module CompletePlugin
      def self.configure(_pluggable, **_options); end
      module ClassMethods; end
      module InstanceMethods; end
    end

    before(:all) do
      Plugins.register_plugin(:complete, CompletePlugin)
    end

    it "should extend class methods" do
      expect(subject).to receive(:extend).with(CompletePlugin::ClassMethods)
      subject.plugin(:complete)
    end

    it "should extend instance methods" do
      expect(subject).to receive(:include).with(CompletePlugin::InstanceMethods)
      subject.plugin(:complete)
    end

    it "should call configure with pluggable" do
      expect(CompletePlugin).to receive(:configure).with(subject, {})
      subject.plugin(:complete)
    end

    it "should call configure with any options" do
      expect(CompletePlugin).to receive(:configure).with(subject, user: { name: "Joe Bloggs"}, price: 4.99)
      subject.plugin(:complete, user: { name: "Joe Bloggs" }, price: 4.99)
    end

    it "should call configure after extending class methods" do
      expect(subject).to receive(:extend).ordered
      expect(CompletePlugin).to receive(:configure).ordered
      subject.plugin(:complete)
    end

    it "should call configure after including instance methods" do
      expect(subject).to receive(:include).ordered
      expect(CompletePlugin).to receive(:configure).ordered
      subject.plugin(:complete)
    end
  end

  context "incomplete plugins" do
    it "should work when there are no class methods" do
      module NoClassMethodsPlugin
        def self.configure(_pluggable, **_options); end
        module InstanceMethods; end
      end

      Plugins.register_plugin(:no_class_methods, NoClassMethodsPlugin)
      expect { subject.plugin(:no_class_methods) }.not_to raise_error
    end

    it "should work when there are no instance methods" do
      module NoInstanceMethodsPlugin
        def self.configure(_pluggable, **_options); end
        module ClassMethods; end
      end

      Plugins.register_plugin(:no_instance_methods, NoInstanceMethodsPlugin)
      expect { subject.plugin(:no_instance_methods) }.not_to raise_error
    end
  end
end
