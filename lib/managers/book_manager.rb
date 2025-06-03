# frozen_string_literal: true

require_relative '../models/book'
require_relative '../handlers/file_handler'

class BookManager
  def initialize
    @books = Book.index
  end

  def display_all_books
    if @books.empty?
      puts 'No books available'
      return
    end
    puts "\n#{'=' * 40}"
    puts 'Available Books'
    puts '=' * 40

    @books.each do |book|
      puts book
    end

    puts '=' * 40
    puts "Books Amount: #{@books.count}"
  end

  def find_book_by_id(book_id)
    @books.find { |book| book.id == book_id.to_i }
  end

  def books_count
    @books.count
  end
end
