require_relative 'lib/library_app'
require_relative 'lib/models/book'
begin
  test = Book.new("1","2","3","4")
  puts test
  app = LibraryApp.new
  app.run
rescue StandardError => e
  puts "Error: #{e.message}"
  puts 'Exit an application'
end
