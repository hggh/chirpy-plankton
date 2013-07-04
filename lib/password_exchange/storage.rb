module PasswordExchange
  class Storage
    class ErrorKeyNotFound<RuntimeError;end
    class ErrorKeyAlreadyExists<RuntimeError;end

    def initialize(config)
      @config = config
      require "password_exchange/storage/#{@config.storage}"
    end

    def get_value(keyname)
      @backend = Storage.const_get(storage_backend_class_name).new(@config)
      value = @backend.get(keyname)
      @backend.delete(keyname)
      crypt = PasswordExchange::Crypter.new(@config.cryptkey, @config.cipher)
      crypt.decrypt(value)
    end

    def set_value(value)
      @backend = Storage.const_get(storage_backend_class_name).new(@config)
      crypt = PasswordExchange::Crypter.new(@config.cryptkey, @config.cipher)
      value = crypt.encrypt(value)
      random = SecureRandom.urlsafe_base64(48,true)
      @backend.set(random, value)
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
