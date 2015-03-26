require 'sinatra'
require 'twitter'
require 'json'
require 'byebug'
require 'dotenv'
Dotenv.load

set :server, 'webrick'
# configuration = JSON.parse(File.read('config.json'))
# configuration = require 'config.json' --> did not work :/

get '/' do
  'Hello, world!'
end

consumer_key = ENV["consumer_key"]
puts consumer_key

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["consumer_key"]
  config.consumer_secret     = ENV["consumer_secret"]
  config.access_token        = ENV["access_token"]
  config.access_token_secret = ENV["access_token_secret"]
end

lat = 37.7749300
lng = -122.4194200
radius = 5000000 #in miles
result_count = 100

get '/tweets' do
  twitterObjects = client.search(params['q'], {result_type: "recent", geocode:"#{lat},#{lng},#{radius}mi"}).take(result_count)
  customTwitterObjects = []
  for twitterObject in twitterObjects
    customTwitterObject = {
      text: twitterObject.text,
      location: {
        lat: twitterObject.geo.coordinates.first,
        long: twitterObject.geo.coordinates.last
      },
      username: twitterObject.user.name
    }
    customTwitterObjects.push(customTwitterObject)
  end
  content_type :json
  customTwitterObjects.to_json
end
