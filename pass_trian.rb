# frozen_string_literal: true

class PassengerTrain < Train
  include Validation

  validate :number, :presence
  validate :number, :format, '^\w{3}-?\w{2}$'

  def initialize(name)
    super
    @type = 'pass'
  end
end
