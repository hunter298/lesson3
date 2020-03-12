# frozen_string_literal: true

class PassCar < Car
  attr_reader :type, :occupied_seats

  def initialize(params)
    super
    @type = 'pass'
    @total_seats = params[:seats]
    @occupied_seats = 0
  end

  def vacant_seats
    @total_seats - @occupied_seats
  end

  def occupy
    if @occupied_seats < @total_seats
      @occupied_seats += 1
    else
      puts 'Car is full!'
    end
  end
end
