class User
  attr_reader :username

  def initialize(username)
    @username = username.sub(/^@/, "")
  end
end

