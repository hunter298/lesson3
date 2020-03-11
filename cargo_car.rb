class CargoCar < Car
  attr_reader :type, :occupied_volume

  def initialize params
    super
    @type = 'cargo'
    @volume = params[:volume]
    @occupied_volume = 0
  end

  def empty_volume
    @volume - @occupied_volume
  end

  def occupy(amount)
    if empty_volume >= amount
      @occupied_volume += amount
    else
      puts 'Not enough space!'
    end
  end
end

