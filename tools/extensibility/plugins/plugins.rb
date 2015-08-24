module Plugins
  def self.locate(name)
    registry.fetch(name) { fail "No plug-in with name '#{name}' has been registered" }
  end

  def self.registry
    @registry ||= {}
  end

  def self.clear
    @registry = {}
  end

  def self.register_plugin(name, mod)
    registry[name] = mod
  end

  def configure(_pluggable, **_options)
  end
end
