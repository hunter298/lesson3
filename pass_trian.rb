class PassengerTrain < Train
  def initialize name
    super
    @type = 'pass'
  end
end