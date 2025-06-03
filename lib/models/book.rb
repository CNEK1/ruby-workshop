# frozen_string_literal: true

class Book
  attr_reader :id, :name, :author, :release_year

  def initialize(id, name, author, release_year)
    @id = id.to_i
    @name = name.strip
    @author = author.strip
    @release_year = release_year.to_i
  end

  def display_info
    puts "ID: #{@id}"
    puts "Name: #{@name}"
    puts "Author: #{@author}"
    puts "Release Year: #{@release_year}"
  end

  def to_s
    "#{@id} #{@name} #{@author} #{@release_year}"
  end

  def ==(other)
    other.is_a?(Book) && other.id == @id
  end

  def self.index
    books_data = FileHandler.read_books_csv
    temp_books = []
    books_data.each do |book_data|
      book = Book.new(
        book_data[:id].to_i,
        book_data[:title],
        book_data[:author],
        book_data[:release_year].to_i
      )
      temp_books << book
    end
    puts "Loaded #{temp_books.count} books."
    temp_books
  rescue StandardError => e
    AppLogger.logger.error("Error in borrowed book index - '#{e.message}'")
    raise
  end
end
