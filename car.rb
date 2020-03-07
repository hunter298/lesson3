class Car
  include Maker
  include InstanceCounter

  def initialize
    register_instance
  end
end