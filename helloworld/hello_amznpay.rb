require 'sinatra'
require 'sinatra/reloader'

require 'amazon_pay'

before do
  @client_id   = ENV.fetch('YOUR_CLIENT_ID')
  @seller_id   = ENV.fetch('YOUR_MERCHANT_ID')
  @merchant_id = ENV.fetch('YOUR_MERCHANT_ID')
  @access_key  = ENV.fetch('YOUR_ACCESS_KEY')
  @secret_key  = ENV.fetch('YOUR_SECRET_KEY')
end

get '/' do
  erb :index
end

get '/logined' do
  erb :logined
end

get '/items' do
  erb :items
end

get '/pay_onetime' do
  erb :pay_onetime
end

post '/pay_onetime' do
  # Step4 Add Order Detail
  client = AmazonPay::Client.new(
      @merchant_id,
      @access_key,
      @secret_key,
      region: :jp, # :jp 指定しないと deny される
      currency_code: :jpy, # :jpy 指定しないと deny される
      sandbox: true,
      log_enabled: true
  )

  amazon_order_reference_id = params[:orderReferenceId]
  amount = 106

  # SetOrderReferenceDetails
  order_reference_details = client.set_order_reference_details(
      amazon_order_reference_id,
      amount,
      seller_note: 'Lorem ipsum dolor',
      seller_order_id: '5678-23',
      store_name: 'CourtAndCherry.com'
  )

  # # Making a call to the ConfirmOrderReference API
  client.confirm_order_reference(amazon_order_reference_id)

  # # Step5 Open Auth
  authorization_reference_id = 'test_authorize_' + Time.now.to_s

  client.authorize(
      amazon_order_reference_id,
      authorization_reference_id,
      amount,
      seller_authorization_note: 'Lorem ipsum dolor'
  )
end

get '/pay_auto' do
  erb :pay_auto
end

post '/pay_onetime' do
end