# DERO Merchant Ruby SDK
Library with bindings for the [DERO Merchant REST API](https://merchant.dero.io/docs) for accepting DERO payments on a Ruby backend.

## Requirements
- A store registered on your [DERO Merchant Dashboard](https://merchant.dero.io/dashboard) to receive an API Key and a Secret Key, required to send requests to the API.
- A Ruby web server.

## Installation
`gem install dero-merchant-ruby-sdk`

## Usage
### Import
`require "deromerchant"`

### Setup
```ruby
dm_client = DeroMerchant::Client.new(
  "API_KEY_OF_YOUR_STORE_GOES_HERE", # REQUIRED
  "SECRET_KEY_OF_YOUR_STORE_GOES_HERE", # REQUIRED
  scheme: "https", # OPTIONAL. Default: https
  host: "merchant.dero.io", # OPTIONAL. Default: merchant.dero.io
  api_version: "v1" # OPTIONAL. Default: v1
)

begin
  res = dm_client.ping()
  puts(res) # {"ping"=>"pong"}
rescue DeroMerchant::APIError => api_err
  # Error returned by the API. Probably invalid API Key.
  puts(api_err)
rescue => exception
  # Somethign went wrong while sending the request.
  # The server is offline or bad scheme/host/api version were provided.
  puts(exception)
end
```

### Create a Payment
```ruby
begin
  # payment = dm_client.create_payment("USD", 1) // USD value will be converted to DERO
  # payment = dm_client.create_payment("EUR", 100) // Same thing goes for EUR and other currencies supported by the CoinGecko API V3
  payment = dm_client.create_payment("DERO", 10)
  
  puts(payment)
=begin
  Hash
  {
    "paymentID"=>"ba5a517df8506a9f55b24d18bb66d316d8df6ed93376c6414c1876d7421764b9", 
    "status"=>"pending", 
    "currency"=>"DERO", 
    "currencyAmount"=>10, 
    "exchangeRate"=>1, 
    "deroAmount"=>"10.000000000000", 
    "atomicDeroAmount"=>10000000000000, 
    "integratedAddress"=>"dETin8HwLs94N6j8zASZjD8htBbQTkhUuicZEYKBG6zQENd8mrhopv3YqaeP3Q9q1RMLHX3PvF4F4Xy1cN3Rndq7daiU7JSmXpBET9APnksErnJCXaBriPySALsG8JWrUt571tRDA4Q1Cb", 
    "creationTime"=>"2020-08-07T14:10:13.775959Z", 
    "ttl"=>60
  }
=end
rescue DeroMerchant::APIError => api_err
  # Handle API Error
rescue => exception
  # Handle exception
end
```

### Get a Payment from its ID
```ruby
begin
  payment_id = "ba5a517df8506a9f55b24d18bb66d316d8df6ed93376c6414c1876d7421764b9"
  payment = dm_client.get_payment(payment_id)
  
  puts(payment)
=begin
  Hash
  {
    "paymentID"=>"ba5a517df8506a9f55b24d18bb66d316d8df6ed93376c6414c1876d7421764b9", 
    "status"=>"pending", 
    "currency"=>"DERO", 
    "currencyAmount"=>10, 
    "exchangeRate"=>1, 
    "deroAmount"=>"10.000000000000", 
    "atomicDeroAmount"=>10000000000000, 
    "integratedAddress"=>"dETin8HwLs94N6j8zASZjD8htBbQTkhUuicZEYKBG6zQENd8mrhopv3YqaeP3Q9q1RMLHX3PvF4F4Xy1cN3Rndq7daiU7JSmXpBET9APnksErnJCXaBriPySALsG8JWrUt571tRDA4Q1Cb", 
    "creationTime"=>"2020-08-07T14:10:13.775959Z", 
    "ttl"=>55
  }
=end
rescue DeroMerchant::APIError => api_err
  # Handle API Error
rescue => exception
  # Handle exception
end
```

### Get an array of Payments from their IDs
```ruby
begin
  payment_ids = ["ba5a517df8506a9f55b24d18bb66d316d8df6ed93376c6414c1876d7421764b9", "95f28cb0a70a10f42e1e748d825cc72a110bae317205d6a4c1c74d8bf8927a24"]
  payments = dm_client.get_payments(payment_ids)
  
  puts(payments)
=begin
  Hashes
  {
    "paymentID"=>"ba5a517df8506a9f55b24d18bb66d316d8df6ed93376c6414c1876d7421764b9", 
    "status"=>"pending", 
    "currency"=>"DERO", 
    "currencyAmount"=>10, 
    "exchangeRate"=>1, 
    "deroAmount"=>"10.000000000000", 
    "atomicDeroAmount"=>10000000000000, 
    "integratedAddress"=>"dETin8HwLs94N6j8zASZjD8htBbQTkhUuicZEYKBG6zQENd8mrhopv3YqaeP3Q9q1RMLHX3PvF4F4Xy1cN3Rndq7daiU7JSmXpBET9APnksErnJCXaBriPySALsG8JWrUt571tRDA4Q1Cb", 
    "creationTime"=>"2020-08-07T14:10:13.775959Z", 
    "ttl"=>51
  }
  {
    "paymentID"=>"95f28cb0a70a10f42e1e748d825cc72a110bae317205d6a4c1c74d8bf8927a24", 
    "status"=>"pending", 
    "currency"=>"DERO", 
    "currencyAmount"=>10, 
    "exchangeRate"=>1, 
    "deroAmount"=>"10.000000000000", 
    "atomicDeroAmount"=>10000000000000, 
    "integratedAddress"=>"dETin8HwLs94N6j8zASZjD8htBbQTkhUuicZEYKBG6zQENd8mrhopv3YqaeP3Q9q1RMLHX3PvF4F4Xy1cN3Rndq7daiU3CDnpe22gezRV3eibbGX4drSePTPo1ye8wrH2c6b6YwysZLssQ", 
    "creationTime"=>"2020-08-07T14:14:38.441926Z", 
    "ttl"=>56
  }
=end
rescue DeroMerchant::APIError => api_err
  # Handle API Error
rescue => exception
  # Handle exception
end
```

### Get an array of filtered Payments
_Not detailed because this endpoint was created for an internal usecase._
```ruby
begin
  res = dm_client.get_filtered_payments({
      "limit" => int,
      "page" => int,
      "sort_by" => string,
      "order_by" => string,
      "filter_status" => string,
      "filter_currency" => string
    }
  )

  puts(res) # Hash
rescue DeroMerchant::APIError => api_err
  # Handle API Error
rescue => exception
  # Handle exception
end
```

### Get Pay helper page URL
```ruby
payment_id = "ba5a517df8506a9f55b24d18bb66d316d8df6ed93376c6414c1876d7421764b9"
pay_url = dm_client.get_pay_helper_url(payment_id)

puts(pay_url) # https://merchant.dero.io/pay/ba5a517df8506a9f55b24d18bb66d316d8df6ed93376c6414c1876d7421764b9
```

### Verify Webhook Signature
When using Webhooks to receive Payment status updates, it is highly suggested to verify the HTTP requests are actually sent by the DERO Merchant server thorugh the X-Signature header.

**Example using Rails**

app/controllers/webhooks_controller.rb
```ruby
require 'deromerchant' # Need to add deromerchant and httparty to Gemfile and run 'bundle install' before

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  WEBHOOK_SECRET_KEY = "WEBHOOK_SECRET_KEY_OF_YOUR_STORE_GOES_HERE"

  def dero_merchant_example
    req_body = request.body.read()
    req_signature = request.headers["X-Signature"]
    valid = DeroMerchant::verify_webhook_signature(req_body, req_signature, WEBHOOK_SECRET_KEY)

    if valid
      # Signature was verified. As such, as long Webhook Secret Key was stored securely, request should be trusted.
      # Proceed with updating the status of the order on your store associated to req_json["paymentID"] accordingly to req_json["status"]
      req_json = JSON.parse(req_body)
      
      puts req_json
=begin
      Hash
      {
        "paymentID"=>"38ad8cf0c5da388fe9b5b44f6641619659c99df6cdece60c6e202acd78e895b1", 
        "status"=>"paid"
      }
=end
    else
      # Signature of the body provided in the request does not match the signature of the body generated using webhook_secret_key.
      # As such, REQUEST SHOULD NOT BE TRUSTED.
      # This could also mean a wrong WEBHOOK_SECRET_KEY was provided as a param, so be extra careful when copying the value from the Dashboard.
    end
  end
end
```

config/routes.rb
```ruby
Rails.application.routes.draw do
  # ...
  post 'dero_merchant_webhook_example', to: 'webhooks#dero_merchant_example'
  # ...
end
```
