require_relative "./crypto_util"

module DeroMerchant
  # Returns the validity of the signature of a webhook request.
  def self.verify_webhook_signature(req_body, req_signature, webhook_secret_key)
    return DeroMerchant::CryptoUtil::valid_mac(req_body, req_signature, webhook_secret_key)
  end
end
