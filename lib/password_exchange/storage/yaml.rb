module PasswordExchange
  class Storage
    class Yaml
      def initialize(config)
        @config = config
        raise "password_exchange.yaml: yaml entry not found" unless @config.yaml
        raise "password_exchange.yaml: yaml: filename not found" unless @config.yaml['filename']
        unless File.exists?(@config.yaml['filename'])
          f = File.open(@config.yaml['filename'], "w+", 0600) 
          f.puts Hash.new.to_yaml
          f.close
        end
      end

      def set(keyname, value)
        yaml = load_file
        raise PasswordExchange::Storage::ErrorKeyAlreadyExists if yaml[keyname]
        yaml[keyname] = value
        save_file(yaml)
      end

      def get(keyname)
        yaml = load_file
        if yaml[keyname]
          return yaml[keyname]
        end
        raise PasswordExchange::Storage::ErrorKeyNotFound
      end

      def delete(keyname)
        yaml = load_file
        if yaml[keyname]
          yaml.delete(keyname)
          save_file(yaml)
        end
      end

      private
      def load_file
        yaml = YAML.load(File.read(@config.yaml['filename']))
        yaml
      end
      def save_file(data)
        f = File.open(@config.yaml['filename'], "w", 0600) 
        f.puts data.to_yaml
        f.close
      end
    end
  end
end
