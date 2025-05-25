class User
  attr_reader :username

  def initialize(username)
    @username = username.strip
    validate_username
  end

  def to_s
    @username
  end

  def ==(other)
    other.is_a?(User) && @username == other.username
  end

  private

  def validate_username
    raise ArgumentError, 'Username cannot be empty' if @username.empty?
    raise ArgumentError, 'Username is too short' if @username.length < 2
  end
end
