# Scrape the following web address: https://www.linkedin.com/company/deloitte/posts/?feedView=all
# Gather all posts that mention the word "data", case-insensitive
# write those posts to a file called "data_posts_DATE.txt"
# Save that file in this directory

require 'nokogiri'
require 'open-uri'
require 'date'
require 'selenium-webdriver'
require 'dotenv'
Dotenv.load

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

api_key = ENV['API_KEY']
api_key_secret = ENV['API_KEY_SECRET']