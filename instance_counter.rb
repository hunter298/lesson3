module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_writer :instances

    def instances
      @instances ||= 0
    end
  end

  module InstanceMethods
    def register_instance
      if self.class.instances != nil
        self.class.instances += 1
      else
        self.class.instances = 1
      end
    end
  end
end

