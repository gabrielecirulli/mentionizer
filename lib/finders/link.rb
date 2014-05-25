require 'twitter_url'
require 'finders/base'
require 'uri'
require 'active_support/core_ext/object/blank'

module Finders
  class Link < Base
    def users
      usernames.map do |username|
        User.new(username)
      end
    end

    def usernames
      document.css('a').map do |element|
        TwitterUrl.new(element['href']).username
      end.compact.uniq
    end
  end
end

