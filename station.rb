require_relative 'train'
require_relative 'route'

class Station
  attr_reader :name, :route, :trains, :stations

  @@stations = []

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
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
    puts "Train number #{train.number} arrived to station #{name}."
  end

  #Может отправлять поезда
  def train_depart(train)
    trains.delete(train)
    puts "Train number #{train.number} departed from station #{name}."
    return self
  end

  def self.stations
    @@stations
  end

end