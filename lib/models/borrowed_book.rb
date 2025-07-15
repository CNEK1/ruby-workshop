# frozen_string_literal: true

class BorrowedBook
  attr_reader :book_id, :username

  BORROWED_BOOKS_FILE = File.join(APP_ROOT, ENV['DATA_FOLDER'], ENV['BORROWED_BOOKS_DB'])

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

    FileHandler.write_to_db_file(BORROWED_BOOKS_FILE, borrowed_books, 'a')
    AppLogger.logger.info("Borrowed Book '#{@book_id}' - #{@username} created successfully.")
  rescue StandardError => e
    AppLogger.logger.error("Error in borrowed book creation: #{e.message}")
    raise
  end

  def self.index
    borrowed_books = []
    FileHandler.read_from_db_file(BORROWED_BOOKS_FILE).each do |line|
      book_id, username = line.split(':')
      borrowed_books << { book_id: book_id.to_i, username: username }
    end
    borrowed_books
  rescue StandardError => e
    AppLogger.logger.error("Error in borrowed book index - '#{e.message}'")
    raise
  end
end
