class User
  attr_reader :username

  def new(username)
    @username = username.sub(/^@/, "")
  end
end

