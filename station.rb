require_relative 'train'
require_relative 'route'

class Station

  attr_reader :name
  attr_accessor :trains, :cargo_trains, :pass_trains
  def initialize name
    @name = name
    @trains = []
    @cargo_trains = []
    @pass_trains = []
  end


  #Может принимать поезда
  def train_arrive train
    self.trains << train
    if train.type == 'cargo'
      self.cargo_trains << train
    elsif train.type == 'pass'
      self.pass_trains << train
    end
    puts "Train number #{train.number} arrived to station #{name}."
  end

  #Может отправлять поезда
  def train_depart train
    self.trains.delete train
    if train.type == 'cargo'
      self.cargo_trains.delete train
    elsif train.type == 'pass'
      self.pass_trains.delete train
    end
    puts "Train number #{train.number} departed from station #{name}."
  end

  #Список поездов на станции в данный момент
  def trains_on_station
    puts "Following trains are at the #{name} station now:"
    trains.each.with_index(1) { |train, index| puts "#{index}. #{train.number}"}
  end

  #Список грузовых поездов на станции в данный момент
  def cargo_trains_on_station
    puts "Following cargo trains are at the #{name} station now:"
    cargo_trains.each.with_index(1) { |train, index| puts "#{index}. #{train.number}"}
  end

  #Список пассажирских поездов на станции в данный момент
  def pass_trains_on_station
    puts "Following passenger trains are at the #{name} station now:"
    pass_trains.each.with_index(1) { |train, index| puts "#{index}. #{train.number}"}
  end

end