module Maker

  def maker=(name)
    self.maker_name = name
  end

  def maker
    maker_name
  end

  protected
  attr_accessor :maker_name

end