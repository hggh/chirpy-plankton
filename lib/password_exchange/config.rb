require 'yaml'

module PasswordExchange
  class Config
   def initialize(filename)
     @filename = filename
     @configuration = open_config(@filename)
   end

   def method_missing(name, *args)
     if @configuration[name.to_s]
       @configuration[name.to_s]
     end
   end

   def open_config(filename)
     YAML.load(File.read(filename))
   end
  end
end
