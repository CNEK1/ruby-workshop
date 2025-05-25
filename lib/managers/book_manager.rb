require_relative '../models/book'
require_relative '../handlers/file_handler'

class BookManager
  def initialize
    @books = []
    load_books
  end

  def load_books

    books_data = FileHandler.read_books_csv
    @books = []

    books_data.each do |book|
      book = Book.new(
        book[:id],
        book[:title],
        book[:author],
        book[:release_year]
      )
      @books << book
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
    puts "Loaded #{@books.count} books"
  rescue StandardError => e
    puts "Error: #{e.message}"
    puts 'Check if books.csv is loaded'
    @books = []

  end

  def display_all_books
    if @books.empty?
      puts 'No books available'
      return
    end
    puts "\n" + '=' * 40
    puts 'Available Books'
    puts '=' * 40

    @books.each_with_index do |book, i|
      puts "#{i}. #{book}"
    end

    puts '=' * 40
    puts "Books Amount: #{@books.count}"
  end

  def find_book_by_id(book_id)
    @books.find { |book| book[:id] == book_id.to_i }
  end

  def get_all_books
    @books.dup
  end

  def books_count
    @books.count
  end

end