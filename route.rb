# frozen_string_literal: true

class Route
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :first_station, :last_station, :station_list
  # attr_accessor_with_history :first_station, :last_station
  strong_accessor id: Integer
  validate :first_station, :type, Station
  validate :last_station, :type, Station

  @@routes = []

  # Имеет начальную и конечную станции
  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    # Имеет список промежуточных станций
    # Точнее список всех станций включая промежуточные
    @station_list = [@first_station, @last_station]
    validate!
    @@routes << self
    register_instance
  end

  # Может добавлять промежуточную станцию в список
  def add_interim_station(station)
    station_list.insert(-2, station)
  end

  # Можетудалять промежуточную станцию из списка
  def remove_station(station)
    station_list.delete(station)
  end

  # Может выводить список всех станций от начальной до конечной
  def show_route
    puts "Trains on route \"#{first_station.name} - #{last_station.name}\" attend stations:"
    station_list.each.with_index(1) { |station, index| puts "#{index}. #{station.name}" }
  end

  def name
    "#{first_station.name} - #{last_station.name}"
  end

  def self.routes
    @@routes
  end

  def valid?
    validate!
    true
  rescue StandardError
    false
  end

end
