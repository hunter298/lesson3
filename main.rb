# frozen_string_literal: true

require_relative 'instance_counter'
require_relative 'maker'
require_relative 'station'
require_relative 'train'
require_relative 'car'
require_relative 'pass_trian'
require_relative 'cargo_train'
require_relative 'pass_car'
require_relative 'cargo_car'
require_relative 'route'

module Main
  OPTIONS = {
    1 => 'create_station', 2 => 'create_train', 3 => 'create_route',
    4 => 'route_add_station', 5 => 'route_remove_station',
    6 => 'train_to_route', 7 => 'train_add_car', 8 => 'train_remove_car',
    9 => 'train_move', 10 => 'station_overview', 11 => 'train_overview'
  }.freeze

  class << self
    def interface
      puts 'Welcome to our railway simulator!'
      user_input = ''
      while user_input != 'exit'
        puts 'What would You like to do?'
        OPTIONS.each { |num, opt| puts "#{num}. #{opt.gsub('_', ' ')}" }
        puts 'Enter "exit" to close program'
        (user_input = gets.chomp) == 'exit' ? abort('Bye!') : send(OPTIONS[user_input.to_i])
      end
    end

    def create_station
      puts 'Enter station name:'
      station_name = gets.chomp
      Station.new(station_name)
      puts "Station #{station_name} successfully created!\n\n"
    end

    def create_train
      puts 'Enter train number:'
      train_number = gets.chomp
      puts "1. Passenger\n2. Cargo"
      pass_or_cargo = gets.chomp.to_i
      if pass_or_cargo == 1
        PassengerTrain.new(train_number)
      elsif pass_or_cargo == 2
        CargoTrain.new(train_number)
      end
      puts "Train #{train_number} constructed successfully!\n\n"
    rescue StandardError => e
      puts e.message
      create_train
    end

    def create_route
      puts 'Choose first station:'
      Station.all.each.with_index(1) { |stn, num| puts "#{num}. #{stn.name}" }
      first_stn_num = gets.chomp.to_i
      puts 'Choose last station:'
      Station.all.each.with_index(1) do |stn, num|
        puts "#{num}. #{stn.name}" if num != first_stn_num
      end
      last_stn_num = gets.chomp.to_i
      Route.new(Station.all[first_stn_num - 1], Station.all[last_stn_num - 1])
      puts "Route created!\n\n"
    end

    def route_add_station
      puts 'Choose route:'
      Route.routes.each.with_index(1) do |route, number|
        puts "#{number}. #{route.first_station.name} - #{route.last_station.name}"
      end
      route_number = gets.chomp.to_i - 1
      puts 'Choose station to add:'
      Station.all.each.with_index(1) do |station, number|
        unless Route.routes[route_number].station_list.include?(station)
          puts "#{number}. #{station.name}"
        end
      end
      station_number = gets.chomp.to_i - 1
      Route.routes[route_number].add_interim_station(Station.all[station_number])
    end

    def route_remove_station
      puts 'Choose route:'
      Route.routes.each.with_index(1) do |route, number|
        puts "#{number}. #{route.first_station.name} - #{route.last_station.name}"
      end
      route_num = gets.chomp.to_i - 1
      puts 'Choose station to remove:'
      Route.routes[route_num].station_list.each.with_index(1) do |stn, num|
        puts "#{num}. #{stn.name}"
      end
      station_num = gets.chomp.to_i - 1
      Route.routes[route_num].remove_station(Route.routes[route_num].station_list[station_num])
    end

    def train_to_route
      puts 'What train You want to assign?'
      train = train_from_list
      puts 'On which route?'
      Route.routes.each.with_index(1) do |route, number|
        puts "#{number}. #{route.first_station.name} - #{route.last_station.name}"
      end
      route_number = gets.chomp.to_i - 1
      train.take_route(Route.routes[route_number])
    end

    def train_add_car
      puts 'What train You want to add car to?'
      train = train_from_list
      if train.type == 'pass'
        puts 'How many seats?'
        seats = gets.chomp.to_i
        train.add_car(PassCar.new(seats: seats))
      elsif train.type == 'cargo'
        puts 'What size? (Volume in m3)'
        size = gets.chomp.to_f
        train.add_car(CargoCar.new(volume: size))
      end
    end

    def train_remove_car
      puts 'What train You want to remove car from?'
      train = train_from_list
      train.cars.pop
    end

    def train_move
      puts 'What train You want to move?'
      train = train_from_list
      puts '(1)Forward of (2)Backward?'
      fwd_or_back = gets.chomp.to_i
      if fwd_or_back == 1
        train.move_forward
      elsif fwd_or_back == 2
        train.move_backward
      end
    end

    # Выводим список поездов на станции
    def station_overview
      puts 'Choose station to browse:'
      Station.all.each.with_index(1) do |station, number|
        puts "#{number}. #{station.name}"
      end
      station_number = gets.chomp.to_i - 1
      puts 'Following trains are at the station now:'
      Station.all[station_number].each_train do |train|
        puts "#{train.type}.train No #{train.number} (#{train.cars.size} cars)."
      end
    end

    # Смотрим список вагонов, а также занимаем место в вагоне через метод occupy_car
    def train_overview
      puts 'Choose train: '
      train = train_from_list
      puts "#{train.type.capitalize}.train number #{train.number}, including cars:"
      num = 1
      if train.is_a? PassengerTrain
        train.each_car do |car|
          puts "#{num}. Passenger wagon. Empty seats: #{car.vacant_seats}."\
          " Occupied seats: #{car.occupied_seats}"
          num += 1
        end
      elsif train.is_a? CargoTrain
        train.each_car do |car|
          puts "#{num}. Cargo wagon. Empty space: #{car.empty_volume}m3."\
          " Cargo loaded #{car.occupied_volume}m3"
          num += 1
        end
      end
      puts "\nDo You want to use any car? (y/n)"
      answer = gets.chomp
      car_occupy train if answer == 'y'
    end

    def car_occupy(train)
      puts 'What car You want to use?'
      car_number = gets.chomp.to_i
      if train.is_a? CargoTrain
        puts 'How much cargo You want to carry?'
        amount_of_cargo = gets.chomp.to_f
        train.cars[car_number - 1].occupy(amount_of_cargo)
      elsif train.is_a? PassengerTrain
        train.cars[car_number - 1].occupy
      end
    end

    def train_from_list
      Train.trains.each_key.with_index(1) { |num, ind| puts "#{ind}. #{num}" }
      train_number = gets.chomp.to_i
      Train.trains.each_key.with_index(1) do |number, index|
        return Train.trains[number] if index == train_number
      end
    end
  end
end

Main.interface
