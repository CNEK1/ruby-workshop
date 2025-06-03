# frozen_string_literal: true

require_relative '../models/borrowed_book'
class BorrowManager
  BORROWED_BOOKS_FILE = '../data/borrowed_books.db'

  def initialize
    @borrowed_books = load_borrowed_books
  end

  def borrow_book(book_id, username)
    return { success: false, message: 'Another user is already has this book!' } if book_borrowed?(book_id.to_i)

    borrowed_book = BorrowedBook.new(book_id.to_i, username)
    borrowed_book.create
    load_borrowed_books
    { success: true, message: 'Successfully borrowed this book' }
  rescue StandardError => e
    AppLogger.logger.error("Borrow book is failed: #{e.message}")
    puts "An error occurred: #{e.message}"
  end

  def return_book(book_id, username)
    book_id = book_id.to_i

    borrowed_book = @borrowed_books.find do |record|
      record[:book_id] == book_id && record[:username] == username
    end

    return { success: false, message: 'You do not have this book' } unless borrowed_book

    @borrowed_books.delete(borrowed_book)
    save_borrowed_books

    { success: true, message: 'Book successfully returned' }
  end

  def get_user_borrowed_books(username)
    @borrowed_books.select { |record| record[:username] == username }
                   .map { |record| record[:book_id] }
  end

  def book_borrowed?(book_id)
    @borrowed_books.any? { |record| record[:book_id] == book_id.to_i }
  end

  def who_borrowed_book(book_id)
    record = @borrowed_books.find { |r| r[:book_id] == book_id.to_i }
    record ? record[:username] : nil
  end

  private

  def load_borrowed_books
    @borrowed_books = BorrowedBook.index
  end

  def save_borrowed_books
    lines = @borrowed_books.map do |record|
      "#{record[:book_id]}:#{record[:username]}"
    end
    begin FileHandler.write_to_db_file(BORROWED_BOOKS_FILE, lines)
    rescue StandardError => e
      puts "Error when writing to #{BORROWED_BOOKS_FILE} - #{e.message}"
    end
  end
end
