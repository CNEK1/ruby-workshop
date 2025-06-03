# frozen_string_literal: true

require 'csv'
class FileHandler
  def self.read_books_csv(filename = '../data/books.csv')
    books_data = []
    begin
      CSV.foreach(filename, headers: true) do |row|
        if row['Book ID'].nil? || row['Book Name'].nil? || row['Author'].nil? || row['Release Year'].nil?
          warn "Warning: Skipping malformed row in '#{filename}' due to missing headers. Row: #{row.to_h.inspect}"
          next
        end
        books_data << {
          id: row['Book ID'],
          title: row['Book Name'],
          author: row['Author'],
          release_year: row['Release Year']
        }
      end
    rescue StandardError => e
      warn "An unexpected error occurred while reading CSV file '#{filename}': #{e.message}"
    end

    books_data
  end

  def self.read_from_db_file(filename)
    return [] unless File.exist? filename

    begin
      File.readlines(filename).map(&:chomp).reject(&:empty?)
    rescue StandardError => e
      puts "Error reading file #{filename}: #{e}"
      []
    end
  end

  def self.write_to_db_file(filename, data, mode = 'w')
    File.open(filename, mode) do |f|
      data.each { |line| f.puts(line) }
    end
  rescue StandardError => e
    puts "Error writing file #{filename}: #{e}"
  end
end
