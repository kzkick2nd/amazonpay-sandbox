# encoding: utf-8

require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cookies'

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
  @profile = {}

  # https://github.com/amzn/amazon-pay-sdk-ruby#get-login-profile-api
  @login = AmazonPay::Login.new(
    @client_id,
    region: :jp,
    sandbox: true
  )

  # The access token is available in the return URL
  # parameters after a user has logged in.
  access_token = cookies[:amazon_Login_accessToken]

  # Make the 'get_user_info' api call.
  @profile = @login.get_login_profile(access_token)

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
      log_enabled: false # ログを出すとエンコーディングエラー吐く。日本語入ってるんかいな？ => 原因わかったらPR
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

  client.close_order_reference(
    amazon_order_reference_id
  )

  "
  <h3>決済完了。メール飛んでるはず</h3>
  <p>
    authotization: #{amazon_authorization_id}<br>
    capture: #{capture_reference_id}<br>
    amount: #{amount}
  </p>
  <a href='/'>トップに戻る</a>
  "
end

get '/pay_auto' do
  erb :pay_auto
end

post '/pay_auto' do
  client = AmazonPay::Client.new(
    @merchant_id,
    @access_key,
    @secret_key,
    sandbox: true,
    region: :jp, # :jp 指定しないと deny される
    currency_code: :jpy, # :jpy 指定しないと deny される
    log_enabled: false
  )
  # These values are grabbed from the Amazon Pay
  # Address and Wallet widgets
  amazon_billing_agreement_id = params[:billingAgreementId]
  # address_consent_token = params[]

  # To get the buyers full address if shipping/tax
  # calculations are needed you can use the following
  # API call to obtain the billing agreement details.
  client.get_billing_agreement_details(
    amazon_billing_agreement_id
    # address_consent_token
  )

  # Next you will need to set the various details
  # for this subscription with the following API call.
  # There are additional optional parameters that
  # are not used below.
  client.set_billing_agreement_details(
    amazon_billing_agreement_id,
    seller_note: 'Your Seller Note',
    seller_billing_agreement_id: 'Your Transaction Id',
    store_name: 'Your Store Name',
    custom_information: 'Additional Information'
  )

  # Make the ConfirmBillingAgreement API call to confirm
  # the Amazon Billing Agreement Id with the details set above.
  # Be sure that everything is set correctly above before
  # confirming.
  client.confirm_billing_agreement(
    amazon_billing_agreement_id
  )

  # The following API call is not needed at this point, but
  # can be used in the future when you need to validate that
  # the payment method is still valid with the associated billing
  # agreement id.
  client.validate_billing_agreement(
    amazon_billing_agreement_id
  )

  # Set the amount for your first authorization.
  amount = '10.00'

  # Set a unique authorization reference id for your
  # first transaction on the billing agreement.
  authorization_reference_id = 'bill_ref_id_' + Time.now.to_i.to_s

  # Now you can authorize your first transaction on the
  # billing agreement id. Every month you can make the
  # same API call to continue charging your buyer
  # with the 'capture_now' parameter set to true. You can
  # also make the Capture API call separately. There are
  # additional optional parameters that are not used
  # below.

  # NOTE res が入ってないぞ => PR 出
  res = client.authorize_on_billing_agreement(
    amazon_billing_agreement_id,
    authorization_reference_id,
    amount,
    currency_code: 'JPY', # :jpy 指定しないと deny される
    seller_authorization_note: 'Your Authorization Note',
    transaction_timeout: 0, # Set to 0 for synchronous mode
    capture_now: true, # Set this to true if you want to capture the amount in the same API call
    seller_note: 'Your Seller Note',
    seller_order_id: 'Your Order Id',
    store_name: 'Your Store Name',
    custom_information: 'Additional Information'
  )

  # You will need the Amazon Authorization Id from the
  # AuthorizeOnBillingAgreement API response if you decide
  # to make the Capture API call separately.
  amazon_authorization_id = res.get_element('AuthorizeOnBillingAgreementResponse/AuthorizeOnBillingAgreementResult/AuthorizationDetails','AmazonAuthorizationId')

  # Set a unique id for your current capture of
  # this payment.
  capture_reference_id = 'Your Unique Id'

  # Make the Capture API call if you did not set the
  # 'capture_now' parameter to 'true'. There are
  # additional optional parameters that are not used
  # below.
  client.capture(
    amazon_authorization_id,
    capture_reference_id,
    amount,
    currency_code: 'USD', # Default: USD
    seller_capture_note: 'Your Capture Note'
  )

  # The following API call should not be made until you
  # are ready to terminate the billing agreement.
  client.close_billing_agreement(
    amazon_billing_agreement_id,
    closure_reason: 'Reason For Closing'
  )
end