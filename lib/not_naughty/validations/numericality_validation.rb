NotNaughty::Validation.load :format

module NotNaughty

  # == Validates numericality of obj's attribute via an regular expression.
  #
  # Unless the validation succeeds an error hash (:attribute => :message)
  # is added to the obj's instance of Errors.
  #
  # <b>Options:</b>
  # <tt>:only_integer</tt>:: validates with <tt>/^[+-]?\d+$/</tt> (false)
  # <tt>:message</tt>:: see NotNaughty::Errors for details
  # <tt>:if</tt>:: see NotNaughty::Validation::Condition for details
  # <tt>:unless</tt>:: see NotNaughty::Validation::Condition for details
  #
  # <b>Example:</b>
  #
  #   obj = '-12.2' #
  #   def obj.errors() @errors ||= NotNauthy::Errors.new end
  #
  #   NumericalityValidation.new({}, :to_s).call obj, :to_s, '-12.2'
  #   obj.errors.on(:to_s).any? # => false
  #
  #   NumericalityValidation.new({:only_integer => true}, :to_s).
  #     call obj, :to_s, '-12.2'
  #
  #   obj.errors.on(:to_s).any? # => true
  class NumericalityValidation < FormatValidation

    def initialize(valid, attributes) #:nodoc:
      valid[:with] = if valid[:only_integer]
        valid[:message] ||= '%s is not an integer.'
        /^[+-]?\d+$/
      else
        valid[:message] ||= '%s is not a number.'
        /^[+-]?\d*\.?\d+$/
      end

      super valid, attributes
    end

  end
end
