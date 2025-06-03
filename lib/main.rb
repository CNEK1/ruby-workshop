# frozen_string_literal: true

require_relative 'library_app'
require_relative 'models/user'

begin
  app = LibraryApp.new
  app.run
rescue StandardError => e
  puts "Error: #{e.message}"
  puts 'Exit an application'
end
