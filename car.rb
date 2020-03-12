# frozen_string_literal: true

class Car
  include Maker
  include InstanceCounter

  def initialize(_params)
    register_instance
  end
end
