module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_writer :validations

    def validate(attr, validation_type, param = 'true')
      @validations ||= []
      case validation_type
      when :presence
        @validations << "raise 'Presence Validation Failed' if #{attr}.nil? || #{attr}.eql?('')"
      when :format
        @validations << "raise 'Format Validation Failed' if #{attr} !~ /#{param}/"
      when :type
        @validations << "raise 'Type Validation Failed' if #{attr}.class != #{param}"
      end
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get(:@validations).each do |validation|
        eval(validation)
      end
    end
  end
end
