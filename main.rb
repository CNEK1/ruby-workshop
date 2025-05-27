require_relative 'lib/library_app'
require_relative 'lib/di/dependency_setup'
require_relative 'lib/models/user'

begin
  container = setup_dependencies
  app = LibraryApp.new(container)
  app.run
rescue StandardError => e
  puts "Error: #{e.message}"
  puts 'Exit an application'
end
