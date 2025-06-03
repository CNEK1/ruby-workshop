# frozen_string_literal: true

require_relative '../handlers/file_handler'
require_relative '../models/user'
require_relative '../errors/authentication_error'

class AuthManager
  def auth_menu
    loop do
      display_menu
      choice = gets.chomp
      case choice
      when '1'
        return handle_user_login
      when '2'
        return handle_user_register
      when '3'
        return nil
      else
        puts 'Unrecognized option! Please choose between 1 and 3.'
      end
    end
  end

  private

  def display_menu
    puts '1. Login to Library App'
    puts '2. Register to Library App'
    puts '3. Exit'
    print 'Choose (1 - 3): '
  end

  def handle_user_register
    username = prompt_for_input('Username: ')
    return unless username

    password = prompt_for_input('Password: ')
    return unless password

    unless User.exist?(username)
      puts 'User already exists.'
      return
    end
    user = User.new(username, password)
    user.create
    user
  rescue StandardError => e
    AppLogger.logger.error("User registration failed: #{e.message}")
    puts "An error occurred: #{e.message}"
  end

  def handle_user_login
    username = prompt_for_input('Username: ')
    return unless username

    password = prompt_for_input('Enter your password: ')
    return unless password

    authenticate_user(username, password)
  end

  def authenticate_user(username, password)
    lines = FileHandler.read_from_db_file('../data/users.db')
    lines.each do |line|
      username_db, hashed_password_db = line.chomp.split(':')
      next unless username_db == username && BCrypt::Password.new(hashed_password_db).is_password?(password)

      AppLogger.logger.info("User '#{username}' authenticated successfully.")
      return User.new(username_db, password)
    end
    AppLogger.logger.error("Authentication failed for user '#{username}'.")
    raise AuthenticationError
  end

  def prompt_for_input(prompt)
    puts prompt
    input = gets.chomp
    return input unless input.empty?

    puts "#{prompt.strip.capitalize} cannot be empty!"
  end
end
