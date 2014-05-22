module Finders
  class Base < Struct.new(:document)
    def users
      []
    end
  end
end

