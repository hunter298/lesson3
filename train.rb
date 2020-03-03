require_relative 'station'
require_relative 'route'

class Train

  #Может возвращать текущую скорость, кол-во вагонов
  attr_reader :number, :type
  attr_accessor :speed, :length, :route

  #Имеет номер, тип, количество вагонов
  def initialize number, type, length
    @number = number
    @type = type
    @length = length
    @speed = 0
    @route = nil
  end

  #Может набирать скорость
  def accelerate
    self.speed += 10
  end

  #Может тормозить
  def break
    self.speed = 0
  end

  #Может прицеплять вагоны, по одному, не на ходу
  def add_car
    if speed == 0
      self.length += 1
      puts "1 car joined  train number #{self.number} "
    else
      puts 'Impossible to connect car under way.'
    end
  end

  #Может отцеплять вагоны, по одному, не на ходу
  def remove_car
    unless length == 0
      if speed == 0
        self.length -= 1
        puts "1 car removed from  train number #{self.number}."
      else
        puts 'Impossible to disconnect car under way.'
      end
    else
      puts 'No cars to disconnect.'
    end
  end

  # Может принимать маршрут следования
  # Не заводил переменную экземпляра @position в конструкторе так как она
  # все равно не работает, если не задан маршрут
  def take_route route
    @route = route
    @position = 0
  end

  # Может перемещаться вперед
  def move_forward
    if route != nil && @position < route.station_list.size
      route.station_list[@position].train_depart self
      @position += 1
      route.station_list[@position].train_arrive self
    else
      puts 'Train can not move forward'
    end
  end

  # Может перемещаться назад
  def move_backward
    if route != nil && @position > 0
      route.station_list[@position].train_depart self
      @position -= 1
      route.station_list[@position].train_arrive self
    else
      puts 'Train can not move backward'
    end
  end

  # Может возвращать текущую позицию
  def show_position
    if route != nil
      if @position == 0
        puts "Current station: #{route.station_list[@position].name}"
        puts "Next station: #{route.station_list[@position + 1].name}"
      elsif @position == -1
        puts "Previous station: #{route.station_list[@position - 1].name}"
        puts "Current station: #{route.station_list[@position].name}"
      else
        puts "Previous station: #{route.station_list[@position - 1].name}"
        puts "Current station: #{route.station_list[@position].name}"
        puts "Next station: #{route.station_list[@position + 1].name}"
      end
    end
  end

end