module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      var_name = "@#{name}".to_sym
      var_history_name = "@#{name}_history".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}_history".to_sym) { instance_variable_get(var_history_name) }
      define_method("#{name}=".to_sym) do |value|
        eval("@#{name}_history ||= []; @#{name}_history << value")
        instance_variable_set(var_name, value)
      end
    end
  end

  def strong_accessor(args_hash)
    args_hash.each do |name, class_name|
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=") do |value|
        if value.is_a? class_name
          instance_variable_set(var_name, value)
        else
          raise "#{name.capitalize} should be only #{class_name} class!"
        end
      end
    end
  end

end
