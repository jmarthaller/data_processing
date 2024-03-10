require 'tty-prompt'

def search_linkedin
  puts "Searching LinkedIn..."
  # Add your LinkedIn search code here
end

def search_twitter
  puts "Searching Twitter..."
  # Add your Twitter search code here
end

def search_blogs
  puts "Searching Company Blogs..."
  # Add your blog search code here
end

prompt = TTY::Prompt.new

loop do
  user_choice = prompt.select("Choose your action?", %w(SearchLinkedIn SearchTwitter SearchCompanyBlogs Exit))

  case user_choice
  when 'SearchLinkedIn'
    search_linkedin
  when 'SearchTwitter'
    search_twitter
  when 'SearchCompanyBlogs'
    search_blogs
  when 'Exit'
    break
  end
end