require_relative 'station'
require_relative 'route'

class Train
  include Maker
  include InstanceCounter

  #Может возвращать текущую скорость, кол-во вагонов
  attr_reader :number, :route, :cars, :type
  attr_accessor :speed

  #Имеет номер, тип, количество вагонов
  def initialize(number)
    @number = number
    @cars = [] # cars.size to return quantity of wagons
    @speed = 0
    @route = nil
    @@trains[number] = self
    register_instance
  end

  #Может набирать скорость
  def accelerate
    @speed += 10
  end

  #Может тормозить
  def break
    @speed = 0
  end

  #Может прицеплять вагоны, по одному, не на ходу
  def add_car(car)
    if speed == 0 && car.type == self.type
      cars << car
      puts "1 car joined  train number #{self.number} "
    else
      puts 'Impossible to connect car'
    end
  end

  #Может отцеплять вагоны, по одному, не на ходу
  def remove_car(car)
    return puts 'No cars to disconnect.' if cars.empty?
    if speed == 0
      cars.delete(car)
      puts "1 car removed from  train number #{number}."
    else
      puts 'Impossible to disconnect car under way.'
    end
  end

  # Может принимать маршрут следования
  # Не заводил переменную экземпляра @position в конструкторе так как она
  # все равно не работает, если не задан маршрут
  def take_route(route)
    @route = route
    route.station_list.first.train_arrive(self)
  end

  # Может перемещаться вперед
  def move_forward
    unless current_station == route.station_list.last
      departure_station = current_station.train_depart(self)
      puts route.station_list[route.station_list.index(departure_station) + 1].train_arrive(self)
    end
  end

  # Может перемещаться назад
  def move_backward
    unless current_station == route.station_list.first
      departure_station = current_station.train_depart(self)
      puts route.station_list[route.station_list.index(departure_station) - 1].train_arrive(self)
    end
  end

  # Может возвращать текущую позицию
  def current_station
    route.station_list.find { |station| station.trains.include?(self) }
  end

  def next_station
    unless current_station == route.station_list.last
      route.station_list[route.station_list.index(current_station) + 1]
    else
      puts "End of route"
    end
  end

  def previous_station
    unless current_station == route.station_list.first
      route.station_list[route.station_list.index(current_station) - 1]
    else
      puts "Begin of route"
    end
  end

  # Принимает номер и возвращает обьект поезд с таким номером или nil если такого не существует
  def self.find search_number
    return @@trains[search_number]
  end

  protected

  @@trains = {}

  def self.trains
    @@trains
  end
end