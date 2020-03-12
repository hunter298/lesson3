class Car
  include Maker
  include InstanceCounter

  def initialize(params)
    register_instance
  end
end