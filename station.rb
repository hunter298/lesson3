# frozen_string_literal: true

class Station
  include InstanceCounter
  include Validation
  extend Accessors

  attr_reader :name, :trains
  # attr_accessor_with_history :name
  strong_accessor id: Integer

  @@stations = []

  def initialize(name)
    # Одно или два сдова с большой буквы
    @name = name.split(' ').each(&:capitalize!).join(' ')
    @trains = []
    validate!(:name, :presence, format: STATION_FORMAT)
    @@stations << self
    register_instance
  end

  # Список поездов на станции в данный момент
  def trains_on_station
    trains.map(&:number)
  end

  # Список грузовых поездов на станции в данный момент
  def cargo_trains_on_station
    trains.select { |train| train.type == 'cargo' }.map(&:number)
  end

  # Список пассажирских поездов на станции в данный момент
  def pass_trains_on_station
    trains.select { |train| train.type == 'pass' }.map(&:number)
  end

  # Может принимать поезда
  def train_arrive(train)
    trains << train
    nil
  end

  # Может отправлять поезда
  def train_depart(train)
    trains.delete(train)
    self
  end

  # Принимает блок и проходит по всем поездам на станции, передавая каждый поезд в блок
  def each_train
    trains.each { |train| yield(train) }
  end

  def self.all
    @@stations
  end

  def valid?
    validate!(:name, :presence, format: STATION_FORMAT)
    true
  rescue
    false
  end

  protected

  # Название станции из одного или двух слов
  STATION_FORMAT = '/^[a-zA-Z]+\s?[a-zA-Z]*$/'
end
