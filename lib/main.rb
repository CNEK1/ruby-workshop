# frozen_string_literal: true

APP_ROOT = File.expand_path('..', __dir__)

$LOAD_PATH.unshift(File.join(APP_ROOT, 'lib'))

require 'dotenv/load'

require_relative 'library_app'

begin
  app = LibraryApp.new
  app.run
rescue StandardError => e
  puts "Error: #{e.message}"
  puts 'Exit an application'
end
