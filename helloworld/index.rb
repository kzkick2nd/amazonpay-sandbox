require 'sinatra'

get '/' do
  "Hello World"
end

get '/frank-says' do
    'Put this in your pipe & smoke it!'
end