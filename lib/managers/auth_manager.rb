require_relative '../handlers/file_handler'

class AuthManager

  def login
    puts "\n=== Welcome to Library App! ==="
    puts "1. Login to Library App"
    puts "2. Register to Library App"
    puts "3. Exit"
    puts "3. Choose (1 - 3)"

    choise = gets.chomp

    case choise
    when "1"
      authenticate_user
    when "2"
      register_user
    when "3"
      exit
    else
      puts "Unrecognized option!"
      nil
    end

    private

    def authenticate_user
      print 'Username: '
      username = gets.chomp

      if username.empty?
        puts "Username cannot be empty!"
        return nil
      end

      puts "Enter your password: "
      password = gets.chomp
      if FileHandler
    end

    end
  end
end
