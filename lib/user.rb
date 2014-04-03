class User
  attr_reader :username

  def initialize(username)
    @username = username.sub(/^@/, "")
  end

  def as_json
    { username: username }
  end
end

