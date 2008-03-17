require 'delegate'
require 'forwardable'
require 'observer'

require 'rubygems'
require 'assistance'
require 'tree'

module Kernel#:nodoc:all
  methods.include? 'send!' or
  alias_method :send!, :send
end

$:.unshift File.dirname(__FILE__)

module NotNaughty
  require 'not_naughty/validator'

  require 'not_naughty/builder'
  require 'not_naughty/validation'
  Validation.add_observer Builder
  
  require 'not_naughty/violation'
  require 'not_naughty/error_handler'
  require 'not_naughty/instance_methods'
  
  # Extended classes get NotNaughty::Builder and NotNaughty::InstanceMethods.
  def self.extended(base)
    base.instance_eval do
      include InstanceMethods
      extend Builder
    end
  end
  
  # call-seq:
  # validator(validator_klass = NotNaughty::Validator, *states = [:default])
  #
  # Returns instance of Validator. This is either the validator's clone of
  # superclass, an instance of the the given descendant of or the
  # <tt>NotNaughty:Validator</tt> himself.
  #
  # <b>Examples:</b>
  #   validator # => Instance of NotNaughty::Validator with :default state
  #   validator :create, :update # ~ - but with :create and :update states
  #   validator AnotherValidator # Instance of AnotherValidator
  #
  #   validator AnotherValidator, :state_a, :state_b
  #
  # The above examples work as long validator is not already called. To reset
  # an already assigned validator set <tt>@validator</tt> to nil.
  def validator(*states)
    @validator ||= if !states.empty?
      validator_klass =
        if states.first.is_a? Class and states.first <= NotNaughty::Validator
          states.shift
        else
          NotNaughty::Validator
        end
      
      validator_klass.new(*states)
      
    elsif superclass.respond_to? :validator
      superclass.validator.clone
      
    else
      NotNaughty::Validator.new
      
    end
  end
  
  # Prepends a call for validation before then given method. If, on call, the
  # validation passes the method is called. Otherwise it raises an
  # NotNaughty::ValidationException or returns false.
  #
  # <b>Example:</b>
  #   validated_before :save # raise ValidationException unless valid?
  def validated_before(method)
    __method = :"#{method}_without_validations"
    alias_method __method, method
    
    define_method method do |*params|
      begin
        if valid? then send! __method else raise errors end
      rescue Exception => error
        self.class.validator.error_handler.raise error
      end
    end
  end
  
end
