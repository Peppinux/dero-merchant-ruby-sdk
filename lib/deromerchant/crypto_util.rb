require "openssl"

module DeroMerchant
  # Cryptography utility functions for generation/verification of HMACs.
  module CryptoUtil
    # Returns the SHA256 hex encoded signature of the message.
    def self.sign_message(message, key)
      return OpenSSL::HMAC.hexdigest("SHA256", [key].pack("H*"), message)
    end

    # Returns whether the signature of the message is valid or not.
    def self.valid_mac(message, message_mac, key)
      signed_message = self.sign_message(message, key)
      return self.secure_compare(message_mac, signed_message)
    end

    # Credits for this function go to Rails' module:
    # https://github.com/rails/rails/blob/fbe2433be6e052a1acac63c7faf287c52ed3c5ba/activesupport/lib/active_support/security_utils.rb
    # released under MIT License.
    #
    # Constant time string comparison, for fixed length strings.
    #
    # The values compared should be of fixed length, such as strings
    # that have already been processed by HMAC. Raises in case of length mismatch.
    def self.fixed_length_secure_compare(a, b)
      raise ArgumentError, "string length mismatch." unless a.bytesize == b.bytesize

      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

    # Credits for this function go to Rails' module:
    # https://github.com/rails/rails/blob/fbe2433be6e052a1acac63c7faf287c52ed3c5ba/activesupport/lib/active_support/security_utils.rb
    # released under MIT License.
    #
    # Constant time string comparison, for variable length strings.
    #
    # The values are first processed by SHA256, so that we don't leak length info
    # via timing attacks.
    def self.secure_compare(a, b)
      fixed_length_secure_compare(::Digest::SHA256.digest(a), ::Digest::SHA256.digest(b)) && a == b
    end
  end
end
