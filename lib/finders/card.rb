require 'finders/base'

module Finders
  class Card < Base
    METAS = %w(twitter:creator twitter:site)
    INVALID_USERNAMES = %w(tumblr)

    def find
      METAS.each do |meta|
        content = meta_content(meta)
        if content && !INVALID_USERNAMES.include?(content)
          return [ User.new(content) ]
        end
      end
      []
    end

    private

    def meta_content(name)
      tag = document.at_css("meta[name='#{name}']")
      if tag
        tag['content']
      end
    end
  end
end

