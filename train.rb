require_relative 'station'
require_relative 'route'

class Train
  #Может возвращать текущую скорость, кол-во вагонов
  attr_reader :number, :type, :route
  attr_accessor :speed, :length

  #Имеет номер, тип, количество вагонов
  def initialize(number, type, length)
    @number = number
    @type = type
    @length = length
    @speed = 0
    @route = nil
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
  def add_car
    if speed == 0
      @length += 1
      puts "1 car joined  train number #{self.number} "
    else
      puts 'Impossible to connect car under way.'
    end
  end

  #Может отцеплять вагоны, по одному, не на ходу
  def remove_car
    return puts 'No cars to disconnect.' if length == 0
    if speed == 0
      @length -= 1
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
end