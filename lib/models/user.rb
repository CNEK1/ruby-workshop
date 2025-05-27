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


  def create_user
    hash_password = hash_password(@password)
    user_data = ["#{@username}:#{hash_password}"]
    begin
      FileHandler.write_to_db_file("data/users.db", user_data,"a")
    rescue StandardError => e
      puts "Error when loading /data/users.db - #{e.message}"
    end
  end

  def self.user_exists?(username)
    begin
      lines = FileHandler.read_from_db_file("data/users.db")
      lines.any? do |line|
        username_db, _ = line.chomp.split(':')
        username_db == username
      end
    rescue StandardError => e
      puts "Error when loading data/users.db - #{e.message}"
      false
    end
  end


  def self.login(username, password)
    begin
      lines = FileHandler.read_from_db_file("data/users.db")
      lines.each do |line|
        username_db, hashed_password_db = line.chomp.split(':')
        if username_db == username && BCrypt::Password.new(hashed_password_db).is_password?(password)
          return User.new(username_db, password)
        end
      end
    rescue StandardError => e
      puts "Error when loading data/users.db - #{e.message}"
    end
    nil
  end

  private
  def hash_password(password)
    BCrypt::Password.create(password)
  end


  def validate_username
    raise ArgumentError, 'Username cannot be empty' if @username.empty?
    raise ArgumentError, 'Username is too short' if @username.length < 2
  end
end
