module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    def validate(attr, vaidation_type, *param)
      error = case vaidation_type
              when :presence
                'Presence Validation' if attr == '' || attr.nil?
              when :type
                'Type Validation' if attr.class != param.first
              when :format
                'Format Validation' if attr.to_s !~ param.first
              end
      error
    end
  end

  module InstanceMethods
    # С помощью метода validate! можно за раз валидировать один или несколько проверок из метода validate
    # После названия объекта :object, вводятся поочередно виды проверок (:presence, :format, :type),
    # Проверки с параметром вводятся в виде хеша (type: String, format: '/\w+\d*/'
    # Параметры после названия обьекта вводятся в любом порядке
    def validate!(object, *validations)
      errors = []
      validations.each do |validation|
        obj_name = "self.#{object}"
        if validation.is_a? Symbol
          errors << eval("self.class.validate(#{obj_name}, :#{validation})")
        else
          validation.each do |valid, param|
          errors << eval("self.class.validate(#{obj_name}, :#{valid}, #{param})")
          end
        end
      end
      raise("Following validations failed: #{errors.compact.join(', ')}") unless errors.compact.empty?
    end
  end
end
