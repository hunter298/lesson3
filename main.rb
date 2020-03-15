require_relative 'instance_counter'
require_relative 'accessors'
require_relative 'validation'
require_relative 'maker'
require_relative 'station'
require_relative 'train'
require_relative 'car'
require_relative 'pass_trian'
require_relative 'cargo_train'
require_relative 'pass_car'
require_relative 'cargo_car'
require_relative 'route'
require_relative 'accessors'
require_relative 'validation'

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
        (user_input = gets.chomp) == 'exit' ? break : send(OPTIONS[user_input.to_i])
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
      first_station = choose_station
      last_station = choose_station([first_station])
      Route.new(first_station, last_station)
      puts "Route created!\n\n"
    end

    def choose_station(already_chosen = [])
      already_chosen.empty? ? (puts 'Choose station:') : (puts 'Choose another station:')
      (all_stations = Station.all).each.with_index(1) do |stn, num|
        puts "#{num}. #{stn.name}" unless already_chosen.include?(stn)
      end
      station_num = gets.chomp.to_i
      all_stations[station_num - 1]
    end

    def choose_route
      puts 'Choose route:'
      (all_routes = Route.routes).each.with_index(1) do |route, number|
        puts "#{number}. #{route.first_station.name} - #{route.last_station.name}"
      end
      all_routes[gets.chomp.to_i - 1]
    end

    def route_add_station
      route = choose_route
      new_station = choose_station(route.station_list)
      route.add_interim_station(new_station)
    end

    def route_remove_station
      route = choose_route
      puts 'Choose station to remove:'
      route.station_list.each.with_index(1) do |stn, num|
        puts "#{num}. #{stn.name}"
      end
      station_num = gets.chomp.to_i - 1
      route.remove_station(route.station_list[station_num])
    end

    def train_to_route
      train = train_from_list
      route = choose_route
      train.take_route(route)
    end

    def train_add_car
      train = train_from_list
      (type = train.type == 'pass') ? (puts 'How many seats?') : (puts 'What size? (Volume in m3)')
      input = gets.chomp
      type ? train.add_car(PassCar.new(seats: input.to_i)) : train.add_car(CargoCar.new(volume: input.to_f))
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
      station = choose_station
      puts 'Following trains are at the station now:'
      station.each_train do |train|
        puts "#{train.type}.train No #{train.number} (#{train.cars.size} cars)."
      end
    end

    # Смотрим список вагонов, а также занимаем место в вагоне через метод occupy_car
    def train_overview
      train = train_from_list
      puts "#{train.type.capitalize}.train No #{train.number}, including cars:"
      train_details train
      puts "\nDo You want to use any car? (y/n)"
      answer = gets.chomp
      car_occupy(train) if answer == 'y'
    end

    def train_details(train)
      num = 1
      if train.is_a? PassengerTrain
        train.each_car do |car|
          puts "#{num}. Passenger wagon. Empty seats: #{car.vacant_seats}. Occupied seats: #{car.occupied_seats}"
          num += 1
        end
      else
        train.each_car do |car|
          puts "#{num}. Cargo wagon. Empty space: #{car.empty_volume}m3. Cargo loaded #{car.occupied_volume}m3"
          num += 1
        end
      end
    end

    def choose_car(train)
      puts 'What car You want to use?'
      car_number = gets.chomp.to_i
      train.cars[car_number - 1]
    end

    def car_occupy(train)
      car = choose_car(train)
      if train.is_a? CargoTrain
        puts 'How much cargo You want to carry?'
        amount_of_cargo = gets.chomp.to_f
        car.occupy(amount_of_cargo)
      elsif train.is_a? PassengerTrain
        car.occupy
      end
    end

    def train_from_list
      puts 'Choose train:'
      Train.trains.each_key.with_index(1) { |num, ind| puts "#{ind}. #{num}" }
      input_number = gets.chomp.to_i
      Train.trains.each_key.with_index(1) do |number, index|
        return Train.trains[number] if index == input_number
      end
    end
  end
end
