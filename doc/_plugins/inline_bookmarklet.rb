require 'uglifier'
require 'cgi'

module Jekyll
  class InlineJavascriptTag < Liquid::Tag
    attr_reader :variant

    def initialize(tag_name, variant, tokens)
      super
      @variant = variant.strip
    end

    def render(context)
      content = <<JS
          (function() {
            s = document.createElement('script');
            s.setAttribute('src', '//gabrielecirulli.github.io/mentionizer/assets/bookmarklet.js?_=' + new Date().getTime());
            s.setAttribute('data-intent', '#{variant}');
            document.body.appendChild(s);
          })();
        ;
JS
      "javascript:" + CGI::escapeHTML(Uglifier.compile(content))
    end
  end
end

Liquid::Template.register_tag('inline_bookmarklet', Jekyll::InlineJavascriptTag)

