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

class Main

  def self.interface
    puts 'Welcome to our railway simulator!'
    options = ['1. Create station', '2. Create train', '3. Create route', '4. Add station to route',
               '5. Remove station from route', '6. Assign train to route', '7. Add car to train',
               '8. Remove car from train', '9. Move train', '10. Browse through stations and trains']

    user_input = ''
    while user_input != 'exit'
      puts 'What would You like to do?'
      puts 'Enter "exit" to close program'
      puts options
      user_input = gets.chomp
      variant = user_input.to_i
      case variant
      when 1
        create_station
      when 2
        create_train
      when 3
        create_route
      when 4
        route_add_station
      when 5
        route_remove_station
      when 6
        train_to_route
      when 7
        train_add_car
      when 8
        train_remove_car
      when 9
        train_move
      when 10
        station_browse
      end
    end
  end

  private

  def self.create_station
    puts 'Enter station name:'
    station_name = gets.chomp
    station = Station.new(station_name.capitalize)
    puts "Station #{station_name} successfully created!"
  end

  def self.create_train
    puts 'Enter train number:'
    train_number = gets.chomp
    puts "1. Passenger\n2. Cargo"
    pass_or_cargo = gets.chomp.to_i
    if pass_or_cargo == 1
      train = PassengerTrain.new(train_number)
    elsif pass_or_cargo == 2
      train = CargoTrain.new(train_number)
    end
    puts "Train #{train_number} constructed successfully!"
  end

  def self.create_route
    puts 'Choose first station:'
    Station.all.each.with_index(1) { |station, number| puts "#{number}. #{station.name}" }
    first_station_number = gets.chomp.to_i
    puts 'Choose last station:'
    Station.all.each.with_index(1) do |station, number|
      puts "#{number}. #{station.name}" if number != first_station_number
    end
    last_station_number = gets.chomp.to_i
    route = Route.new(Station.all[first_station_number - 1], Station.all[last_station_number - 1])
  end

  def self.route_add_station
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

  def self.route_remove_station
    puts 'Choose route:'
    Route.routes.each.with_index(1) do |route, number|
      puts "#{number}. #{route.first_station.name} - #{route.last_station.name}"
    end
    route_number = gets.chomp.to_i - 1
    puts 'Choose station to remove:'
    Route.routes[route_number].station_list.each.with_index(1) do |station, number|
      puts "#{number}. #{station.name}"
    end
    station_number = gets.chomp.to_i - 1
    Route.routes[route_number].remove_station(Route.routes[route_number].station_list[station_number])
    Route.routes[route_number].station_list.each { |station| puts station.name }
  end

  def self.train_to_route
    puts 'What train You want to assign?'
    train = train_from_list
    puts 'On which route?'
    Route.routes.each.with_index(1) { |route, number| puts "#{number}. #{route.first_station.name} - #{route.last_station.name}" }
    route_number = gets.chomp.to_i - 1
    train.take_route(Route.routes[route_number])
  end

  def self.train_add_car
    puts 'What train You want to add car to?'
    train = train_from_list
    if train.type == 'pass'
      train.add_car(PassCar.new)
    elsif train.type == 'cargo'
      train.add_car(CargoCar.new)
    end
  end

  def self.train_remove_car
    puts 'What train You want to remove car from?'
    train = train_from_list
    train.cars.pop
  end

  def self.train_move
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

  def self.station_browse
    puts 'Choose station to browse:'
    Station.all.each.with_index(1) do |station, number|
      puts "#{number}. #{station.name}"
    end
    station_number = gets.chomp.to_i - 1
    puts 'Following trains are at the station now:'
    Station.all[station_number].trains.each.with_index(1) do |train, number|
      puts "#{number}. #{train.number}"
    end
  end

  def self.train_from_list
    Train.trains.each_key.with_index(1) { |number, index| puts "#{index}. #{number}" }
    train_number = gets.chomp.to_i
    Train.trains.each_key.with_index(1) { |number, index| return Train.trains[number] if index == train_number }
  end
end


