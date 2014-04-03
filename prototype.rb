require 'rubygems'
require 'bundler/setup'

require "json"

require_relative './lib/analyzer'

urls = JSON.parse(File.read("posts.json"))

urls.each do |url|
  puts
  puts url
  puts Analyzer.new(url).users.map(&:username).inspect
end




# User score = occurrences * followers * multiplier
# Multiplier = 2 if link is in the http://twitter.com/madeofcode format or meta tag twitter:creator

# Potential methods
# Check each A tag for urls pointing to twitter

