require 'csv'
class FileHandler
  def self.read_books_csv(filename = 'data/books.csv')
    unless File.exist? filename
      raise "File not found: #{filename}"
    end

    books_data = []

    begin
      CSV.foreach(filename, headers: true) do |row|
        books_data << {
          id: row['Book ID'],
          title: row['Book Name'],
          author: row['Author'],
          release_year: row['Release Year']
        }
      end
    rescue => e
      raise "Error reading file #{filename}: #{e}"
    end
    books_data
  end

  def self.read_from_db_file(filename)
    return [] unless File.exist? filename

    begin
      File.readlines(filename).map(&:chomp).reject(&:empty?)
    rescue => e
      puts "Error reading file #{filename}: #{e}"
      []
    end
  end

  def self.write_to_db_file(filename, data)
    begin
      File.open(filename, 'a') do |f|
        data.each {|line| f.puts(line)}
      end
    rescue => e
      puts "Error writing file #{filename}: #{e}"
    end
  end

end
