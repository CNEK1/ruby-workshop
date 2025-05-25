require_relative 'models/user'
require_relative 'managers/book_manager'
class LibraryApp
  def initialize
    @current_user = nil
    puts 'Initialize of library app'
    @book_manager = BookManager.new
  end

  def run
    display_welcome_message
    authenticate_user
    main_loop if @current_user
  end

  private

  def display_welcome_message
    puts "\n#{'=' * 30}"
    puts 'Welcome to Library App'
    puts '=' * 30
  end

  def authenticate_user
    loop do
      print 'Enter username: '
      username = gets.chomp

      begin
        @current_user = User.new(username)
        puts "Welcome #{username}!"
        break
      rescue ArgumentError => e
        puts "Error: #{e.message}"
        puts 'Try again'
      end
    end
  end

  def main_loop
    loop do
      display_menu
      choice = get_user_choice
      case choice
      when 1
        @book_manager.display_all_books
      when 2
        puts 'Function is not available'
      when 3
        puts 'Function is not available'
      when 4
        puts "Bye, #{@current_user}!"
        break
      else
        puts 'Invalid choice'
      end
    end
  end

  def display_menu
    puts "\n#{'-' * 20}"
    puts 'Main Menu'
    puts '-' * 20
    puts '1. List available books'
    puts '2. Borrow a book'
    puts '3. Return a book'
    puts '4. Exit'
    puts '-' * 20
  end

  def get_user_choice
    puts 'Choose an action (1 - 4): '
    input = gets.chomp
    input.to_i
  end
end