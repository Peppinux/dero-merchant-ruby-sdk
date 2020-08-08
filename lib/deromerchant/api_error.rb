module DeroMerchant
  # Exception that represents the error object returned by the API.
  class APIError < StandardError
    # Error code returned by the API.
    attr_reader :code
    # Error message returned by the API.
    attr_reader :message

    def initialize(code, message)
      @code = code
      @message = message
      msg = "DeroMerchant Client: API Error: #{@code}: #{@message}"
      super(msg)
    end
  end
end
