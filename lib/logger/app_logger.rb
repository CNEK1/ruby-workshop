# frozen_string_literal: true

require 'logger'

module AppLogger
  LOGGER_FILE = File.join(APP_ROOT, ENV['LOGS_FOLDER'], ENV['LOGS'])
  def self.logger
    @logger ||= Logger.new(LOGGER_FILE, 'daily')
  end
end
