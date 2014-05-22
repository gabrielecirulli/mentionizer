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

  def matching_finder
    @matching_finder ||= finders.find do |finder|
      finder.users.any?
    end
  end

  def users
    if matching_finder
      matching_finder.users
    else
      []
    end
  end

  private

  def finders
    @finders ||= FINDERS.map do |finder_klass|
      finder_klass.new(document)
    end
  end

  def document
    @document ||= Nokogiri::HTML.parse(html)
  end
end

