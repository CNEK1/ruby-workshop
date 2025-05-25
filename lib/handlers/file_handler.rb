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

end
