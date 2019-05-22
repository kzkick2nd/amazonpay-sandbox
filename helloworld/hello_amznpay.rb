require 'sinatra'
require 'sinatra/reloader'

before do
  @client_id = ENV.fetch('YOUR_CLIENT_ID')
  @seller_id = ENV.fetch('YOUR_MERCHANT_ID')
end

get '/' do
  erb :index
end

get '/redirected' do
  "Hello World"
end
