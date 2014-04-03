require_relative './finders'
require_relative './user'

require 'nokogiri'

class Analyzer < Struct.new(:html)
  FINDERS = [
    Finders::Card,
    Finders::ShareIntent,
    Finders::Link
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

