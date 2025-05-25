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
    books_data.each do |book_data|
      book = Book.new(
        book_data[:id],
        book_data[:title],
        book_data[:author],
        book_data[:release_year]
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
end