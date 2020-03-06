require_relative 'main_methods'

puts 'Welcome to our railway simulator!'
options = ['1. Create station', '2. Create train', '3. Create route', '4. Add station to route',
           '5. Remove station from route', '6. Assign train to route', '7. Add car to train',
           '8. Remove car from train', '9. Move train', '10. Browse through stations and trains']

user_input = ''
while user_input != 'exit'

  puts 'What would You like to do?'
  puts 'Enter "exit" to close program'
  puts options
  user_input = gets.chomp.to_i
  case user_input
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
  else
    puts "You should choose number from 1 to 10"
  end
end