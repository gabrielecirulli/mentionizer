require_relative './finders'
require_relative './user'

require "nokogiri"
require "rest-client"

class Analyzer < Struct.new(:url)
  FINDERS = [
    Finders::Card,
    Finders::ShareIntent,
    Finders::Link,
    Finders::Username
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

  def html
    @html ||= RestClient.get(url)
  end
end

