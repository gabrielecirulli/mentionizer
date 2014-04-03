require_relative './base'

module Finders
  class Card < Base
    def find
      if meta_tag
        [ User.new(meta_tag['content']) ]
      else
        []
      end
    end

    private

    def meta_tag
      @meta_tag ||= document.at_css("meta[name='twitter:creator']")
    end
  end
end

