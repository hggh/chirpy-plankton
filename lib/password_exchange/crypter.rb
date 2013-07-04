require 'openssl'
require 'digest'

module PasswordExchange
  class Crypter
    def initialize(cryptkey, cipher = 'AES-256-CBC')
      @cipher = cipher
      if(cryptkey.kind_of?(String) && 32 != cryptkey.bytesize)
        @cryptkey = Digest::SHA256.digest(cryptkey) if(cryptkey.kind_of?(String) && 32 != cryptkey.bytesize)
      else
        @cryptkey = cryptkey
      end
    end

    def encrypt(data)
       crypt = OpenSSL::Cipher.new(@cipher)
       crypt.encrypt
       crypt.key = @cryptkey
       cdata = crypt.update(data) + crypt.final
       [cdata].pack('m')
    end

    def decrypt(data)
       crypt = OpenSSL::Cipher.new(@cipher)
       crypt.decrypt
       crypt.key = @cryptkey
       crypt.update(data.unpack('m')[0]) + crypt.final
    end
  end
end
