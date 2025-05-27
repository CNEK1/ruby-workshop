require 'bcrypt'
class User
  attr_reader :username, :password

  def initialize(username, password = nil)
    @username = username.strip
    validate_username
    @password = password
  end

  def to_s
    @username
  end

  def ==(other)
    other.is_a?(User) && @username == other.username
  end

  def self.hash_password(password)
    BCrypt::Password.create(password)
  end

  def authenticate(password)
    BCrypt::Password.new(@password) == password
  end

  private

  def validate_username
    raise ArgumentError, 'Username cannot be empty' if @username.empty?
    raise ArgumentError, 'Username is too short' if @username.length < 2
  end
end
