class Route
  include InstanceCounter

  attr_reader :first_station, :last_station, :station_list

  @@routes = []

  #Имеет начальную и конечную станции
  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    #Имеет список промежуточных станций
    #Точнее список всех станций включая промежуточные
    @station_list = [@first_station, @last_station]
    validate!
    @@routes << self
    register_instance
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

  def self.routes
    @@routes
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  protected

  def validate!
    unless (first_station.is_a? Station) && (last_station.is_a? Station)
    raise "Route can be created only between two Stations!"
    end
  end
end


