require_relative '../managers/borrow_manager'
require_relative '../managers/auth_manager'
require_relative '../managers/book_manager'

require_relative 'dependency_container'

def setup_dependencies
  container = DependencyContainer.new

  container.register(:book_manager) {BookManager.new}
  container.register(:auth_manager) {AuthManager.new}
  container.register(:borrow_manager) {BorrowManager.new}

  container
end