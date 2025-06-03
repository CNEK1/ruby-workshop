# frozen_string_literal: true

class BorrowedBook
  attr_reader :book_id, :username

  def initialize(book_id, username)
    @book_id = book_id
    @username = username
  end

  def to_s
    @username
  end

  def ==(other)
    other.is_a?(BorrowedBook) && @username == other.username && @book_id == other.book_id
  end

  def create
    borrowed_books = ["#{@book_id}:#{@username}"]

    FileHandler.write_to_db_file('../data/borrowed_books.db', borrowed_books, 'a')
    AppLogger.logger.info("Borrowed Book '#{@book_id}' - #{@username} created successfully.")
  rescue StandardError => e
    AppLogger.logger.error("Error in borrowed book creation: #{e.message}")
    raise
  end

  def self.exist?(username, book_id)
    FileHandler.read_from_db_file('../data/borrowed_books.db').each do |line|
      book_id_from_file, username_from_file = line.split(':')
      username_from_file == username && book_id_from_file == book_id
    end
  rescue StandardError => e
    AppLogger.logger.error("Error in borrowed book exists: #{username} - #{book_id} - '#{e.message}'")
    raise
  end

  def self.index
    borrowed_books = []
    FileHandler.read_from_db_file('../data/borrowed_books.db').each do |line|
      book_id, username = line.split(':')
      borrowed_books << { book_id: book_id.to_i, username: username }
    end
    borrowed_books
  rescue StandardError => e
    AppLogger.logger.error("Error in borrowed book index - '#{e.message}'")
    raise
  end
end
