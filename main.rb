require_relative 'lib/library_app'

begin
  app = LibraryApp.new
  app.run
rescue StandardError => e
  puts "Error: #{e.message}"
  puts 'Exit an application'
end
