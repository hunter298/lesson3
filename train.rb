# frozen_string_literal: true

class Train
  include Maker
  include InstanceCounter
  extend Accessors
  include Validation

  # Может возвращать текущую скорость, кол-во вагонов
  attr_reader :number, :route, :cars
  attr_accessor_with_history :speed
  strong_accessor id: Integer
  validate :number, :format, '^\w{3}-?\w{2}$'

  @@trains = {}

  # Имеет номер, тип, количество вагонов
  def initialize(number)
    @number = number
    @cars = [] # cars.size to return quantity of wagons
    @speed = 0
    @route = nil
    validate!
    @@trains[number] = self
    register_instance
  end

  # Может набирать скорость
  def accelerate
    @speed += 10
  end

  # Может тормозить
  def break
    @speed = 0
  end

  # Может прицеплять вагоны, по одному, не на ходу
  def add_car(car)
    if speed.zero? && car.type == type
      cars << car
    else
      puts 'Impossible to connect car'
    end
  end

  # Может отцеплять вагоны, по одному, не на ходу
  def remove_car(car)
    return puts 'No cars to disconnect.' if cars.empty?

    if speed.zero?
      cars.delete(car)
    else
      puts 'Impossible to disconnect car under way.'
    end
  end

  def self.trains
    @@trains
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
    return if current_station == route.station_list.last

    departure_station = current_station.train_depart(self)
    route.station_list[route.station_list.index(departure_station) + 1].train_arrive(self)
  end

  # Может перемещаться назад
  def move_backward
    return if current_station == route.station_list.first

    departure_station = current_station.train_depart(self)
    route.station_list[route.station_list.index(departure_station) - 1].train_arrive(self)
  end

  # Может возвращать текущую позицию
  def current_station
    route.station_list.find { |station| station.trains.include?(self) }
  end

  def next_station
    if current_station == route.station_list.last
      puts 'End of route'
    else
      route.station_list[route.station_list.index(current_station) + 1]
    end
  end

  def previous_station
    if current_station == route.station_list.first
      puts 'Begin of route'
    else
      route.station_list[route.station_list.index(current_station) - 1]
    end
  end

  # Принимает номер и возвращает обьект поезд с таким номером или nil если такого не существует
  def self.find(search_number)
    @@trains[search_number]
  end

  def valid?
    validate!(:number, :presence, format: NUMBER_FORMAT)
    true
  rescue
    false
  end

  # Принимает блок и проходит по всем вагонам поезда, передавая каждый вагон в блок
  def each_car
    cars.each { |car| yield(car) }
  end

  protected

  NUMBER_FORMAT = '/^\w{3}-?\w{2}$/'

end
