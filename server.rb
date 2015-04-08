require 'sinatra'
require 'twitter'
require 'json'
require 'byebug'
require 'dotenv'
require 'erubis'

Dotenv.load

set :server, 'webrick'

get '/' do
  send_file File.join('public', 'index.html')
end

consumer_key = ENV["consumer_key"]
puts consumer_key

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV["consumer_key"]
  config.consumer_secret     = ENV["consumer_secret"]
  config.access_token        = ENV["access_token"]
  config.access_token_secret = ENV["access_token_secret"]
end

post '/tweets' do
  lat = 36.575835
  lng = -94.746094
  radius = 5000 #in miles
  result_count = 100
  puts "  SHOULD GO TO TWITTER"
  puts "----#{params['term']}-----"
  twitterObjects = client.search(
    params['term'],
    {
      result_type: "recent",
      geocode:"#{lat},#{lng},#{radius}mi",
      count: result_count
    }
  )

  puts "TWITTER COUNT = #{twitterObjects.count}"

  filteredByGeo = twitterObjects.reject {|t| t.geo.coordinates.nil? }
  puts "FILTERED TWITTER COUNT = #{filteredByGeo.count}"

  cleanTweets = []
  filteredByGeo.each do |twitterObject|
    cleanTweets.push({
      text: twitterObject.text,
      username: twitterObject.user.name,
      location: {
        lat: twitterObject.geo.coordinates.first,
        long: twitterObject.geo.coordinates.last
      }
    })
  end

  # puts "CLEAN TWEET COUNT = #{cleanTweets.count}"

  content_type :json
  @tweets = cleanTweets.to_json
  @tweets
end
