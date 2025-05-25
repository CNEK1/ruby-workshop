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

  private
  def validate_book_data
    raise StandardError, 'Id can not be less than 0' if @id <=0
    raise StandardError, 'Book name can not be empty' if @name.nil? || @name.empty?
    raise StandardError, 'Author name can not be empty' if @author.nil? || @author.empty?
    raise StandardError, 'Release year can not be empty' if @release_year.nil? || @release_year <= 0
  end
end

