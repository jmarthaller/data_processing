# Scrape the following web address: https://www.linkedin.com/company/deloitte/posts/?feedView=all
# Gather all posts that mention the word "data", case-insensitive
# write those posts to a file called "data_posts_DATE.txt"
# Save that file in this directory

require 'nokogiri'
require 'open-uri'
require 'date'
require 'selenium-webdriver'
require 'dotenv'
require 'oauth2'
Dotenv.load('.env')

def scrape_posts
  # scrape the linkedin page
  url = "https://www.linkedin.com/company/deloitte/posts/?feedView=all"

  # setup selenium to use Chrome
  driver = Selenium::WebDriver.for :chrome
  driver.navigate.to url

  # wait for JavaScript to load
  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { driver.page_source }

  # parse page with Nokogiri
  doc = Nokogiri::HTML(driver.page_source)

  # find all posts
  posts = doc.css('.feed-shared-update-v2__description')
  data_posts = posts.select { |post| post.text.downcase.include?("data") }
  puts data_posts

  # write to file
  date = Date.today
  filename = "data_posts_#{date}.txt"
  File.open(filename, 'w') do |file|
    posts.each do |post|
      # puts post.text
      file.puts post.text
    end
  end

  # quit the driver
  driver.quit
end
# scrape_posts



# Scan Linkedin, stakeholder blogs, twitter, etc. 
# for mentions of the words "data", "A.I. || Artificial Intelligence", "CDO || Chief Data Officer || Chief Technology Officer"
# Cobble those together, saving (if available) a link to the post itself, a relevant date, 
# Save that to a file called "data_mentions_DATE.txt"
# Do this for all member companies of the Data Coalition
# Save that file in this directory

# api_key = ENV['API_KEY']
# api_key_secret = ENV['API_KEY_SECRET']
# bearer_token = ENV['BEARER_TOKEN']

require 'net/http'
require 'uri'
# def test_twitter_access
#   uri = URI('https://api.twitter.com/2/tweets/search/recent?query=from:twitterdev')  # replace with your URL
#   http = Net::HTTP.new(uri.host, uri.port)

#   request = Net::HTTP::Get.new(uri.request_uri)
#   request['Authorization'] = "Bearer #{ENV['BEARER_TOKEN']}"

#   response = http.request(request)

#   puts response.body
# end
# test_twitter_access

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

require 'net/http'
require 'uri'
require 'json'

def search_tweets(user, word, bearer_token)
  base_url = 'https://api.twitter.com/2/tweets/search/recent'
  query = URI.encode_www_form('query' => "from:#{user} #{word}")
  url = URI("#{base_url}?#{query}")
  require 'pry'; binding.pry
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
