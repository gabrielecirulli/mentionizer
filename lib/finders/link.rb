require 'finders/base'
require 'uri'
require 'active_support/core_ext/object/blank'

module Finders
  class Link < Base
    VALID_SCHEMES = %w(http https)
    VALID_DOMAINS = %w(twitter.com www.twitter.com)
    INVALID_USERNAMES = %w(share about privacy jobs)

    def users
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
      if url =~ %r{^//}
        url = 'http:' + url
      end

      uri = URI(url)

      return nil unless VALID_SCHEMES.include?(uri.scheme)
      return nil unless VALID_DOMAINS.include?(uri.host)

      chunks = uri.path.split(/\//).select(&:present?)

      return nil if chunks.size != 1
      return nil if INVALID_USERNAMES.include?(chunks.first)

      chunks.first
    rescue URI::InvalidURIError, ArgumentError
      nil
    end
  end
end

