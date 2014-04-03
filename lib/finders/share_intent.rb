require_relative './base'

module Finders
  class ShareIntent < Base
    INTENT_URL = "https://twitter.com/share"

    def find
      if intent_links
        intent_links.map { |link| User.new(link['data-via']) }
      else
        []
      end
    end

    def intent_links
      @intent_links ||= document.css("a[href='#{INTENT_URL}'][data-via]")
    end
  end
end

