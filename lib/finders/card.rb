require_relative './base'

module Finders
  class Card < Base
    METAS = %w(twitter:creator twitter:site)

    def find
      METAS.each do |meta|
        content = meta_content(meta)
        return [ User.new(content) ] if content
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

