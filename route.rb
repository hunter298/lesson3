require_relative 'train'
require_relative 'station'

class Route
  attr_accessor :station_list
  attr_reader :first_station, :last_station

  #Имеет начальную и конечную станции
  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    #Имеет список промежуточных станций
    #Точнее список всех станций включая промежуточные
    @station_list = [@first_station, @last_station]
  end

  #Может добавлять промежуточную станцию в список
  def add_interim_station(station)
    station_list.insert(-2, station)
  end

  #Можетудалять промежуточную станцию из списка
  def remove_station(station)
    station_list.delete(station)
  end

  #Может выводить список всех станций от начальной до конечной
  def show_route
    puts "Trains on route \"#{first_station.name} - #{last_station.name}\" attend stations:"
    station_list.each.with_index(1) { |station, index| puts "#{index}. #{station.name}" }
  end
end