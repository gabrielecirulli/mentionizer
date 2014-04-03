require_relative './base'
require 'uri'

module Finders
  class Link < Base
    VALID_SCHEMES = %w(http https)
    VALID_DOMAINS = %w(twitter.com www.twitter.com)

    def find
      usernames.map do |username|
        User.new(username)
      end
    end

    def usernames
      document.css('a').map do |element|
        parse_username(element['href'])
      end.compact.uniq
    end

    def parse_username(url)
      uri = URI(url)
      interesting = VALID_SCHEMES.include?(uri.scheme) &&
                    VALID_DOMAINS.include?(uri.host)

      if interesting
        uri.path.gsub(/^\//, '')
      end
    rescue ArgumentError
      nil
    end
  end
end

