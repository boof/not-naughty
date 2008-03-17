module NotNaughty
  
  # == Container for failed validations.
  #
  # ...
  class Violation < RuntimeError
    extend Forwardable
    
    def_delegators :@errors, :empty?, :clear, :[], :each
    
    include Enumerable
    
    def initialize() #:nodoc:
      @errors = Hash.new {|h, k| h[k] = []}
    end
    # Adds an error for the given attribute.
    def add(k, msg)  @errors[k] << msg end
    
    # Returns an array of fully-formatted error messages.
    def full_messages
      @errors.inject([]) do |messages, k_errors| k, errors = *k_errors
        errors.each {|e| messages << eval(e.inspect.delete('\\') % k) }
        messages
      end
    end
    
    # Returns an array of evaluated error messages for given attribute.
    def on(attribute)
      @errors[attribute].map do |message|
        eval(message.inspect.delete('\\') % attribute)
      end
    end
    
  end
  
end
