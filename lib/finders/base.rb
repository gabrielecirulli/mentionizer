module Finders
  class Base < Struct.new(:document)
    def find
      []
    end
  end
end

