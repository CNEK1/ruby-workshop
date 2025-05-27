class DependencyContainer
  def initialize
    @dependencies = {}
  end
  def register(name, &block)
    @dependencies[name] = block
  end
  def resolve(name)
    @dependencies[name].call
  end
end