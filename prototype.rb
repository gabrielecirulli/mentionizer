require 'rubygems'
require 'bundler/setup'

require 'json'
require 'rest-client'

require_relative './lib/analyzer'

urls = JSON.parse(File.read('posts.json'))

urls.shuffle.each do |url|
  puts
  puts url
  html = RestClient.get(url) rescue nil
  puts Analyzer.new(html).users.map(&:username).inspect
end

# .fn[itemprop='author']
# meta[name='author']



# User score = occurrences * followers * multiplier
# Multiplier = 2 if link is in the http://twitter.com/madeofcode format or meta tag twitter:creator

# Potential methods
# Check each A tag for urls pointing to twitter

