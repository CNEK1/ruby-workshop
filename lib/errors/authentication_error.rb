# frozen_string_literal: true

class AuthenticationError < StandardError
  def initialize(msg = 'Invalid username or password.')
    super
  end
end
