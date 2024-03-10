require 'tty-prompt'

def search_linkedin(company, keyword)
  puts "Searching LinkedIn for posts from #{company} that feature references to the word #{keyword}"
end

def search_twitter(company, keyword)
  puts "Searching Twitter for posts from #{company} that feature references to the word #{keyword}"
end

def search_blogs
  puts "Searching Company Blogs..."
  # Add your blog search code here
end

prompt = TTY::Prompt.new

loop do
  user_choice = prompt.select("Choose your action", %w(SearchLinkedIn SearchTwitter SearchCompanyBlogs Exit))

  case user_choice
  when 'SearchLinkedIn'
    puts "what company do you want to search for?"
    company = gets.chomp
    puts "what keyword do you want to search for?"
    keyword = gets.chomp
    search_linkedin(company, keyword)
  when 'SearchTwitter'
    puts "what company do you want to search for?"
    company = gets.chomp
    puts "what keyword do you want to search for?"
    keyword = gets.chomp
    search_twitter(company, keyword)
  when 'SearchCompanyBlogs'
    search_blogs
  when 'Exit'
    break
  end
end