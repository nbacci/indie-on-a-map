require 'sinatra'
require 'twitter'
set :server, 'webrick'
configuration = require 'config.json'

get '/' do
  'Hello, world!'
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = configuration.consumer_key
  config.consumer_secret     = configuration.consumer_secret
  # config.access_token        = "YOUR_ACCESS_TOKEN"
  # config.access_token_secret = "YOUR_ACCESS_SECRET"
end

get '/tweets' do
  client.search(params['q'], result_type: "recent").take(10).each do |tweet|
    puts tweet.text
  end
  'return tweets for ' + params['q']
end
