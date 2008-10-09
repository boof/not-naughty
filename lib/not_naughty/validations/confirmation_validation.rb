module NotNaughty

  # == Validates confirmaton of obj's attribute via <tt>:eql?</tt> call against the _appropiate_ confirmation attribute.
  #
  # Unless the validation succeeds an error hash (:attribute => :message)
  # is added to the obj's instance of Errors.
  #
  # <b>Options:</b>
  # <tt>:message</tt>:: see NotNaughty::Errors for details
  # <tt>:if</tt>::      see NotNaughty::Validation::Condition for details
  # <tt>:unless</tt>::  see NotNaughty::Validation::Condition for details
  #
  # <b>Example:</b>
  #
  #   obj = 'abc'
  #   def obj.errors() @errors ||= NotNauthy::Errors.new end
  #   def obj.to_s_confirmation() '123 end
  #
  #   ConfirmationValidation.new({}, :to_s).call obj, :to_s, 'abc'
  #   obj.errors.on(:to_s).any? # => true
  class ConfirmationValidation < Validation

    def initialize(valid, attributes) #:nodoc:
      valid = Marshal.load Marshal.dump(valid)
      valid[:message] ||= '%s could not be confirmed.'

      if valid[:allow_blank] || valid[:allow_nil]
        valid[:allow] = valid[:allow_blank] ? :blank? : :nil?
        super valid, attributes, &confirmation_block_with_exception(valid)
      else
        super valid, attributes, &confirmation_block(valid)
      end
    end

    protected
    def confirmation_block_with_exception(valid)
      proc do |obj, attr, value|
        value.send valid[:allow] or
        obj.send(:"#{ attr }_confirmation") == value or
        obj.errors.add attr, valid[:message]
      end
    end
    def confirmation_block(valid)
      proc do |obj, attr, value|
        obj.send(:"#{ attr }_confirmation") == value or
        obj.errors.add attr, valid[:message]
      end
    end
  end
end
