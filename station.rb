class Station
  include InstanceCounter

  attr_reader :name, :route, :trains, :all

  @@stations = []

  def initialize(name)
    # Одно или два сдова с большой буквы
    @name = (name.split(' ').each { |word| word.capitalize! }.join(' '))
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  #Список поездов на станции в данный момент
  def trains_on_station
    trains.map { |train| train.number }
  end

  #Список грузовых поездов на станции в данный момент
  def cargo_trains_on_station
    trains.select { |train| train.type == 'cargo' }.map { |cargo_train| cargo_train.number }
  end

  #Список пассажирских поездов на станции в данный момент
  def pass_trains_on_station
    trains.select { |train| train.type == 'pass' }.map { |pass_train| pass_train.number }
  end

  #Может принимать поезда
  def train_arrive(train)
    trains << train
    return nil
  end

  #Может отправлять поезда
  def train_depart(train)
    trains.delete(train)
    return self
  end

  # Принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок
  def process_trains
    trains.each { |train| yield(train) }
  end

  def self.all
    @@stations
  end



  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  # Название станции из одного или двух слов
  STATION_FORMAT = /^[a-zA-Z]+\s?[a-zA-Z]*$/

  def validate!
    raise "Only letters!" if name =~ /\d/
    raise "Too long! 15 letters max." if name.length > 15
    raise "Wrong format! One or two words, only letter, not nil." if name !~ STATION_FORMAT
  end

end

