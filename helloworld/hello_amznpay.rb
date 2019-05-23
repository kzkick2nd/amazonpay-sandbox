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

  # https://github.com/amzn/amazon-pay-sdk-ruby#get-login-profile-api
  login = AmazonPay::Login.new(
    @client_id,
    region: :jp,
    sandbox: true
  )

  @login = login

  # The access token is available in the return URL
  # parameters after a user has logged in.
  access_token = params['access_token']

  # Make the 'get_user_info' api call.
  @profile = login.get_login_profile(access_token)

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

  # Making a call to the ConfirmOrderReference API
  client.confirm_order_reference(amazon_order_reference_id)

  # Step5 Open Auth
  authorization_reference_id = 'auth_ref_id_' + Time.now.to_i.to_s

  res_auth = client.authorize(
      amazon_order_reference_id,
      authorization_reference_id,
      amount,
      currency_code: 'JPY', # :jpy 指定しないと deny される
      seller_authorization_note: 'Lorem ipsum dolor',
      transaction_timeout: 0 # Set to 0 for synchronous mode
  )

  amazon_authorization_id = res_auth.get_element('AuthorizeResponse/AuthorizeResult/AuthorizationDetails','AmazonAuthorizationId')

  capture_reference_id = 'cap_ref_id_' + Time.now.to_i.to_s

  res_cap = client.capture(
    amazon_authorization_id,
    capture_reference_id,
    amount,
    seller_capture_note: 'Lorem ipsum dolor'
  )

end

get '/pay_auto' do
  erb :pay_auto
end

post '/pay_onetime' do
end