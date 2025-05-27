class BorrowManager
  BORROWED_BOOKS_FILE = 'data/borrowed_books.db'

  def initialize
    @borrowed_books = load_borrowed_books
  end

  def borrow_book(book_id, username)
    book_id = book_id.to_i

    if book_borrowed?(book_id)
      return { success: false, message: 'Another user already has this book' }
    end

    borrow_record = "#{book_id}:#{username}\n"
    append_borrow_record(borrow_record)

    @borrowed_books << { book_id: book_id, username: username }

    { success: true, message: 'Successfully borrowed this book' }
  end

  def return_book(book_id, username)
    book_id = book_id.to_i

    borrowed_book = @borrowed_books.find do |record|
      record[:book_id] == book_id && record[:username] == username
    end

    unless borrowed_book
      return { success: false, message: 'You do not have this book' }
    end

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
    return [] unless File.exist?(BORROWED_BOOKS_FILE)

    begin
      lines = FileHandler.read_from_db_file(BORROWED_BOOKS_FILE)
      lines.map do |line|
        book_id,username = line.split(':')
        {book_id: book_id.to_i, username: username}
      end
    rescue StandardError => e
      puts "Error when loading #{BORROWED_BOOKS_FILE} - #{e.message}"
    end
  end

  def append_borrow_record(borrow_record)
    begin
      File.open(BORROWED_BOOKS_FILE, 'a') do |file|
        file.write(borrow_record)
      end
    rescue StandardError => e
      puts "Error when writing to #{BORROWED_BOOKS_FILE} - #{e.message}"
    end
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