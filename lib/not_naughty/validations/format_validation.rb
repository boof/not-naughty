module NotNaughty

  # == Validates format of obj's attribute via the <tt>:match</tt> method.
  #
  # Unless the validation succeeds an error hash (:attribute => :message)
  # is added to the obj's instance of Errors.
  #
  # <b>Options:</b>
  # <tt>:with</tt>::    object that checks via a <tt>:match</tt> call
  # <tt>:message</tt>:: see NotNaughty::Errors for details
  # <tt>:if</tt>::      see NotNaughty::Validation::Condition for details
  # <tt>:unless</tt>::  see NotNaughty::Validation::Condition for details
  #
  # <b>Example:</b>
  #
  #   obj = 'abc'
  #   def obj.errors() @errors ||= NotNauthy::Errors.new end
  #
  #   FormatValidation.new({:with => /[a-z]/}, :to_s).call obj, :to_s, 'abc'
  #   obj.errors.on(:to_s).any? # => false
  #
  #   FormatValidation.new({:with => /[A-Z]/}, :to_s).call obj, :to_s, 'abc'
  #   obj.errors.on(:to_s) # => ["Format of to_s does not match."]
  class FormatValidation < Validation

    VALIDATION = 

    # Predefined matchers.
    PREDEFINED = {
      :email => /[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/,
      :ip => /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/
    }

    def initialize(valid, attributes) #:nodoc:
      valid[:with] = PREDEFINED.fetch valid[:with] if valid[:with].is_a? Symbol
      valid[:with].respond_to? :match or
      raise ArgumentError, "#{ valid[:with].inspect } doesn't :match"

      valid[:message] ||= '%s does not match format.'

      if valid[:allow_blank] || valid[:allow_nil]
        valid[:allow] = valid[:allow_blank] ? :blank? : :nil?
        super valid, attributes, &matching_block_with_exception(valid)
      else
        super valid, attributes, &matching_block(valid)
      end
    end

    protected
    def matching_block_with_exception(valid)
      proc do |obj, attr, value|
        value.send valid[:allow] or
        valid[:with].match value or
        obj.errors.add attr, valid[:message]
      end
    end
    def matching_block(valid)
      proc do |obj, attr, value|
        valid[:with].match value or
        obj.errors.add attr, valid[:message]
      end
    end

  end
end
