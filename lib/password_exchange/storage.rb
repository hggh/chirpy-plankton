module PasswordExchange
  class Storage
    class ErrorKeyNotFound<RuntimeError;end
    class ErrorKeyAlreadyExists<RuntimeError;end

    def initialize(config)
      @config = config
      require "password_exchange/storage/#{@config.storage}"
    end

    def get_values(keyname)
      @backend = Storage.const_get(storage_backend_class_name).new(@config)
      data = @backend.get(keyname)
      password = data[:password]
      @backend.delete(keyname)
      crypt = PasswordExchange::Crypter.new(@config.cryptkey, @config.cipher)
      password = crypt.decrypt(password)
      data[:password] = password
      data
    end

    def set_values(values)
      @backend = Storage.const_get(storage_backend_class_name).new(@config)
      crypt = PasswordExchange::Crypter.new(@config.cryptkey, @config.cipher)
      password = values[:password]
      password = crypt.encrypt(password).gsub(/\s+/, "")
      random = SecureRandom.urlsafe_base64(48,true)
      values[:password] = password
      @backend.set(random, values)
      random
    end

    private
    def storage_backend_class_name
      class_name = @config.storage
      class_name[0] = class_name[0].capitalize
      class_name
    end
  end
end
