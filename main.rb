# Scan Linkedin, stakeholder blogs, twitter, etc. 
# for mentions of the words "data", "A.I. || Artificial Intelligence", "CDO || Chief Data Officer || Chief Technology Officer"
# Cobble those together, saving (if available) a link to the post itself, a relevant date, 
# Save that to a file called "data_mentions_DATE.txt"
# Do this for all member companies of the Data Coalition
# Save that file in this directory

require 'nokogiri'
require 'open-uri'
require 'date'
require 'selenium-webdriver'
require 'dotenv'
require 'oauth2'
require 'net/http'
require 'uri'
require 'json'
Dotenv.load('.env')


def test_linkedin_access
  client_id = ENV['LINKEDIN_CLIENT_ID']
  client_secret = ENV['LINKEDIN_CLIENT_SECRET']

  client = OAuth2::Client.new(client_id, client_secret, site: 'https://www.linkedin.com')
  auth_url = client.auth_code.authorize_url(redirect_uri: 'http://localhost:3000/oauth2/callback')

  puts "Open the following URL in your browser and authorize the app, then enter the code you get back: #{auth_url}"

  print "Enter the code you received: "
  code = gets.chomp

  access_token = client.auth_code.get_token(code, redirect_uri: 'http://localhost:3000/oauth2/callback')

  puts "Your access token is: #{access_token.token}"
end
# test_linkedin_access


def search_tweets(user, word, bearer_token)
  base_url = 'https://api.twitter.com/2/tweets/search/recent'
  query = URI.encode_www_form('query' => "from:#{user} #{word}")
  url = URI("#{base_url}?#{query}")

  request = Net::HTTP::Get.new(url)
  request['Authorization'] = "Bearer #{bearer_token}"

  response = Net::HTTP.start(url.hostname, url.port, use_ssl: url.scheme == 'https') do |http|
    http.request(request)
  end

  JSON.parse(response.body)
end

bearer_token = ENV['TWITTER_BEARER_TOKEN']
user = 'Deloitte'
word = 'data'

tweets = search_tweets(user, word, bearer_token)

puts tweets