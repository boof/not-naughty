module NotNaughty
  module InstanceMethods
    
    # Returns instance of Errors.
    def errors() @errors ||= ::NotNaughty::Errors.new end
    
    # Returns true if all validations passed
    def valid?
      validate
      errors.empty?
    end
    
    # Clears errors and validates.
    def validate
      errors.clear
      self.class.validator.invoke self
    end
    
  end
end