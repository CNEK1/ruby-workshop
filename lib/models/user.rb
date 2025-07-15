# frozen_string_literal: true

require 'bcrypt'
require_relative '../logger/app_logger'
class User
  attr_reader :username, :password

  USERS_DB_FILE = File.join(APP_ROOT, ENV['DATA_FOLDER'], ENV['USERS_DB'])

  def initialize(username, password)
    @username = username.strip
    @password = password.strip
    validate
  end

  def to_s
    @username
  end

  def ==(other)
    other.is_a?(User) && @username == other.username
  end

  def create
    hash_password = BCrypt::Password.create(@password)
    user_data = ["#{@username}:#{hash_password}"]

    FileHandler.write_to_db_file(USERS_DB_FILE, user_data, 'a')
    AppLogger.logger.info("User '#{@username}' created successfully.")
  rescue StandardError => e
    AppLogger.logger.error("Error in user creation: #{e.message}")
    raise
  end

  def self.exist?(username)
    FileHandler.read_from_db_file(USERS_DB_FILE).each do |line|
      username_from_file, = line.split(':')
      return true if username_from_file == username
    end
    false
  rescue StandardError => e
    AppLogger.logger.error("Error in user exists: #{username} - '#{e.message}'")
    raise
  end

  private

  def validate
    validate_username
    validate_password
  end

  def validate_username
    raise ArgumentError, 'Username cannot be empty' if @username.empty?
    raise ArgumentError, 'Username is too short' if @username.length < 2
  end

  def validate_password
    raise ArgumentError, 'Password cannot be empty' if @password.empty?
    raise ArgumentError, 'Password is too short' if @password.length < 4
  end
end
