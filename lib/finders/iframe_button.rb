require 'finders/base'
require 'active_support/core_ext/object/blank'

module Finders
  class IframeButton < Base
    VALID_SCHEMES = %w(http https)
    VALID_DOMAINS = %w(platform.twitter.com)
    VALID_PARAMS = %w(via screen_name)

    def users
      usernames.map do |username|
        User.new(username)
      end
    end

    def usernames
      document.css("iframe").map do |iframe|
        parse_username(iframe['src'])
      end.compact.uniq
    end

    def parse_username(url)
      if url =~ %r{^//}
        url = 'http:' + url
      end

      uri = URI(url)

      return nil unless VALID_SCHEMES.include?(uri.scheme)
      return nil unless VALID_DOMAINS.include?(uri.host)
      return nil unless uri.fragment.present?

      params = Rack::Utils.parse_query(uri.fragment)
      params.values_at(VALID_PARAMS).first
    rescue URI::InvalidURIError, ArgumentError
      nil
    end
  end
end

