module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :validations

    def validate(var, type, param = 'true')
      @validations ||= []
      @validations << { var: var, type: type, params: param }
    end
  end

  module InstanceMethods
    def validate!
      self.class.instance_variable_get(:@validations).each do |validation|
        send("validate_#{validation[:type]}".to_sym, instance_variable_get("@#{validation[:var]}".to_sym), validation[:params])
      end
    end

    def validate_presence(var, param)
      raise 'Presence Validation Failed' if var.nil? || var.eql?('')
    end

    def validate_format(var, param)
      raise 'Format Validation Failed' if var !~ param
    end

    def validate_type(var, param)
      raise 'Type validation Failed' unless var.is_a? param
    end
    end
  end
