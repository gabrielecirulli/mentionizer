require "json"
require "open-uri"
require "nokogiri"

posts = JSON.parse(File.read("posts.json"))

puts "Got #{posts.size} posts."

url = posts.sample
puts "Sampled post: #{url}"

doc = Nokogiri::HTML.parse(url)





# User score = occurrences * followers * multiplier
# Multiplier = 2 if link is in the http://twitter.com/madeofcode format or meta tag twitter:creator

# Potential methods
# Check each A tag for urls pointing to twitter

