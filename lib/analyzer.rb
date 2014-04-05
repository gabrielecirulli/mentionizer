require 'finders'
require 'user'

require 'nokogiri'

class Analyzer < Struct.new(:html)
  FINDERS = [
    Finders::Card,
    Finders::ShareIntent,
    Finders::IframeButton,
    Finders::Link,
  ]

  def users
    FINDERS.each do |finder_klass|
      finder = finder_klass.new(document)
      users = finder.find
      return users if users.count > 0
    end
    []
  end

  private

  def document
    @document ||= Nokogiri::HTML.parse(html)
  end
end

