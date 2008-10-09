module NotNaughty

  # == Validates presence of obj's attribute via the <tt>:blank?</tt> method.
  #
  # Unless the validation succeeds an error hash (:attribute => :message)
  # is added to the obj's instance of Errors.
  #
  # <b>Options:</b>
  # <tt>:message</tt>:: see NotNaughty::Errors for details
  # <tt>:if</tt>:: see NotNaughty::Validation::Condition for details
  # <tt>:unless</tt>:: see NotNaughty::Validation::Condition for details
  #
  # <b>Example:</b>
  #
  #   obj = '' # blank? => true
  #   def obj.errors() @errors ||= NotNauthy::Errors.new end
  #
  #   PresenceValidation.new({}, :to_s).call obj, :to_s, ''
  #   obj.errors.on(:to_s) # => ["To s is not present."]
  class PresenceValidation < Validation

    def initialize(valid, attributes) #:nodoc:
      valid[:message] ||= '%s is not present.'

      super valid, attributes do |obj, attr, value|
        value.blank? and
        obj.errors.add attr, valid[:message]
      end
    end

  end
end
