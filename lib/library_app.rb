require_relative 'models/user'
require_relative 'managers/book_manager'
require_relative 'managers/borrow_manager'
class LibraryApp
  def initialize
    @current_user = nil
    puts 'Initialize of library app'
    @book_manager = BookManager.new
    @borrow_manager = BorrowManager.new
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
        FileHandler.write_to_db_file('data/users.db', [username])
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
        borrow_book
      when 3
        return_book
      when 4
        puts "Bye, #{@current_user}!"
        break
      else
        puts 'Invalid choice'
      end
    end
  end
  
  def return_book
    borrowed_book_ids = @borrow_manager.get_user_borrowed_books(@current_user.username)

    if borrowed_book_ids.empty?
      puts "You don't have any books yet"
      return
    end

    puts "\nYour books:"
    puts '-' * 30
    borrowed_book_ids.each do |book_id|
      book = @book_manager.find_book_by_id(book_id)
      puts book if book
    end

    print "\nPut book id to return: "
    book_id = gets.chomp.to_i

    unless borrowed_book_ids.include?(book_id)
      puts "You dont have book with ID #{book_id}."
      return
    end

    book = @book_manager.find_book_by_id(book_id)
    puts "Returning: #{book}"
    print 'Confirm (y/n): '
    confirm = gets.chomp.downcase

    if ['y', 'yes'].include?(confirm)
      result = @borrow_manager.return_book(book_id, @current_user.username)
      puts result[:message]
    else
      puts 'Operation denied'
    end
  end
  def borrow_book
    if @book_manager.books_count.zero?
      puts 'No available books found'
      return
    end

    @book_manager.display_all_books
    print "\nType id of wanted book: "
    book_id = gets.chomp.to_i

    book = @book_manager.find_book_by_id(book_id)

    unless book
      puts "Book not found: #{book_id}"
      return
    end

    if @borrow_manager.book_borrowed?(book_id)
      borrower = @borrow_manager.who_borrowed_book(book_id)
      puts "Borrowed book found for #{borrower}"
      return
    end
    puts "You choose book #{book_id}"
    print 'Confirm (y/n): '
    confirm = gets.chomp.downcase

    if ['y', 'yes'].include?(confirm)
      result = @borrow_manager.borrow_book(book_id, @current_user.username)
      puts result[:message]
    else
      puts 'Operation denied'
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