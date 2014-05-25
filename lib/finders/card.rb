require 'twitter_url'
require 'finders/base'

module Finders
  class Card < Base
    METAS = %w(twitter:creator twitter:site)
    INVALID_USERNAMES = %w(tumblr wordpressdotcom jetpack)

    def users
      METAS.each do |meta|
        content = meta_content(meta)
        if content
          user = User.new(content)
          if !INVALID_USERNAMES.include?(user.username)
            return [ user ]
          end
        end
      end
      []
    end

    private

    def meta_content(name)
      tag = document.at_css("meta[name='#{name}']")
      if tag
        content = tag['content']
        TwitterUrl.new(content).username || content
      end
    end
  end
end

