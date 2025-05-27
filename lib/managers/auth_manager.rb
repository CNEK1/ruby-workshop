require_relative '../handlers/file_handler'
require_relative '../models/user'

class AuthManager
  def auth_menu
    loop do
      display_menu
      choice = gets.chomp
      case choice
      when "1"
        return login_user
      when "2"
        return register_user
      when "3"
        return nil
      else
        puts "Unrecognized option! Please choose between 1 and 3."
      end
    end
  end

  private

  def display_menu
    puts "1. Login to Library App"
    puts "2. Register to Library App"
    puts "3. Exit"
    print "Choose (1 - 3): "
  end

  def register_user
    username = prompt_for_input('Username: ')
    return unless username

    password = prompt_for_input('Password: ')
    return unless password

    if User.user_exists?(username)
      puts 'This username already exists. Please choose a different username.'
      return nil
    end

    user = User.new(username, password)
    if user.create_user
      puts 'User registered successfully!'
      user
    else
      puts 'Registration failed due to an error.'
      nil
    end
  end

  def login_user
    username = prompt_for_input('Username: ')
    return unless username

    password = prompt_for_input('Enter your password: ')
    return unless password

    user = User.login(username, password)
    if user
      puts 'Login successful!'
      user
    else
      if User.user_exists?(username)
        puts 'Invalid username or password!'
      else
        puts 'User does not exist!'
      end
      nil
    end
  end

  def prompt_for_input(prompt)
    print prompt
    input = gets.chomp
    return input unless input.empty?

    puts "#{prompt.strip.capitalize} cannot be empty!"
    nil
  end
end