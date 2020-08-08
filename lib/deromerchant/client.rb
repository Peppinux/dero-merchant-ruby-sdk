require "httparty"
require "net/http"
require "json"
require_relative "./crypto_util"
require_relative "./api_error"

module DeroMerchant
  # Dero Merchant Client. Has methods to interact with the Dero Merchant REST API.
  class Client
    DEFAULT_SCHEME = "https"
    DEFAULT_HOST = "merchant.dero.io"
    DEFAULT_API_VERSION = "v1"

    # Number of the seconds before a connection to the API times out.
    attr_accessor :timeout

    def initialize(api_key, secret_key, scheme:DEFAULT_SCHEME, host:DEFAULT_HOST, api_version:DEFAULT_API_VERSION)
      @scheme = scheme
      @host = host
      @api_version = api_version
      @base_url = "#{@scheme}://#{@host}/api/#{@api_version}"
      @timeout = 10

      @api_key = api_key
      @secret_key = secret_key
    end

    # Sends a request to the API.
    def send_request(method, endpoint, query_params: {}, payload: {}, sign_body: false)
      url = @base_url + endpoint
      headers = {
        "User-Agent" => "DeroMerchant_Client_Ruby/1.0",
        "X-API-Key" => @api_key
      }

      res = nil

      if method == Net::HTTP::Get
        res = HTTParty.get(url, :headers => headers, :query => query_params, timeout: @timeout)
      elsif method == Net::HTTP::Post
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "applciation/json"
        
        json_payload = JSON.generate(payload)

        if sign_body == true
          signature = DeroMerchant::CryptoUtil::sign_message(json_payload, @secret_key)
          headers["X-Signature"] = signature
        end

        res = HTTParty.post(url, body: json_payload,  :headers => headers, :query => query_params, timeout: @timeout)
      else
        raise ArgumentError.new("method must be Net::HTTP::Get or Net::HTTP::Post")
      end

      res_json = nil

      begin
        res_json = JSON.parse(res.body)
      rescue
        # Do nothing
      end

      if res.code < 200 || res.code > 299
        if res_json != nil
          raise DeroMerchant::APIError.new(res_json["error"]["code"], res_json["error"]["message"])
        else
          if res.code == 404
            raise StandardError.new("DeroMerchant Client: error 404: page #{res.request.last_uri.to_s} not found")
          else
            raise StandardError.new("DeroMerchant Client: error #{res.status_code} returned by #{res.request.last_uri.to_s}")
          end
        end
      else
        return res_json
      end
    end

    # Pings the API.
    def ping()
      return self.send_request(
        Net::HTTP::Get,
        "/ping"
      )
    end

    # Creates a new payment.
    def create_payment(currency, amount)
      return self.send_request(
        Net::HTTP::Post,
        "/payment",
        payload: {
          "currency" => currency,
          "amount" => amount
        },
        sign_body: true
      )
    end

    # Gets a payment from its ID.
    def get_payment(payment_id)
      return self.send_request(
        Net::HTTP::Get,
        "/payment/#{payment_id}"
      )
    end

    # Gets payments from their IDs.
    def get_payments(payment_ids)
      return self.send_request(
        Net::HTTP::Post,
        "/payments",
        payload: payment_ids
      )
    end

    # Gets filtered payments.
    def get_filtered_payments(opts = {})
      return self.send_request(
        Net::HTTP::Get,
        "/payments",
        query_params: opts
      )
    end

    # Gets the URL of the Pay helper page of the payment ID.
    def get_pay_helper_url(payment_id)
      return "#{@scheme}://#{@host}/pay/#{payment_id}"
    end
  end
end
