require_relative 'lib/library_app'
require_relative 'lib/handlers/file_handler'
require_relative 'lib/managers/book_manager'
begin
  app = LibraryApp.new
  app.run
rescue StandardError => e
  puts "Error: #{e.message}"
  puts 'Exit an application'
end
