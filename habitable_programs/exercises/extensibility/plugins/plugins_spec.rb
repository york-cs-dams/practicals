require_relative "plugins"

describe Plugins do
  subject { Plugins }

  before(:each) do
    Plugins.clear
  end

  it "should locate plugins by name" do
    dummy_plugin = Module.new
    Plugins.register_plugin(:dummy, dummy_plugin)

    expect(Plugins.locate(:dummy)).to eq(dummy_plugin)
  end

  it "should raise an error when locating a plugin that does not exist" do
    expect { Plugins.locate(:dummy) }.to raise_error("No plug-in with name 'dummy' has been registered")
  end

  context "when used by a plugin" do
    it "should provide a default implementation of configure" do
      dummy_plugin = Module.new.extend(Plugins)
      expect(dummy_plugin.methods).to include(:configure)
    end
  end
end
