require_relative "plugins"

module Pluggable
  def plugin(mod_name, **options)
    mod = Plugins.locate(mod_name)
    extend mod::ClassMethods if defined?(mod::ClassMethods)
    include mod::InstanceMethods if defined?(mod::InstanceMethods)
    mod.configure(self, options)
  end
end
