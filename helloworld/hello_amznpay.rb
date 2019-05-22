require 'sinatra'
require 'sinatra/reloader'
require 'amazon_pay'

before do
  @client_id = ENV.fetch('YOUR_CLIENT_ID')
  @seller_id = ENV.fetch('YOUR_MERCHANT_ID')
end

get '/' do
  erb :index
end

get '/redirected' do
  erb :redirected
end

post '/pay' do
  merchant_id = ENV.fetch('YOUR_MERCHANT_ID')
  access_key  = ENV.fetch('YOUR_ACCESS_KEY')
  secret_key  = ENV.fetch('YOUR_SECRET_KEY')

  client = AmazonPay::Client.new(
      merchant_id,
      access_key,
      secret_key,
      sandbox: true,
      currency_code: :usd,
      region: :na
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

  redirect '/'
end