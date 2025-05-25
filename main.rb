require_relative 'lib/library_app'
require_relative 'lib/handlers/file_handler'
begin
  books = FileHandler.read_books_csv
  puts books
  app = LibraryApp.new
  app.run
rescue StandardError => e
  puts "Error: #{e.message}"
  puts 'Exit an application'
end
