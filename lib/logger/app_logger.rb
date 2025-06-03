# frozen_string_literal: true

require 'logger'

module AppLogger
  def self.logger
    @logger ||= Logger.new('logs/application.log', 'daily')
  end
end
