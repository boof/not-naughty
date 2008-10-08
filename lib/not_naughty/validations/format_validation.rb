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

    # Predefined matchers.
    DEFINITIONS = {
      :email => /[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#\$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/,
      :ip => /(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)/
    }

    def initialize(opts, attributes) #:nodoc:
      format_matcher = if Symbol === opts[:with] then DEFINITIONS[opts[:with]]
      elsif opts[:with].respond_to? :match then opts[:with]
      end or raise ArgumentError, "#{ opts[:with].inspect } doesn't :match"

      msg = opts[:message] || '%s does not match format.'

      if opts[:allow_blank] or opts[:allow_nil]
        pass = opts[:allow_blank] ? :blank? : :nil?

        super opts, attributes do |obj, attr, val|
          val.send pass or format_matcher.match val or
          obj.errors.add attr, msg
        end
      else
        super opts, attributes do |obj, attr, val|
          format_matcher.match val or
          obj.errors.add attr, msg
        end
      end
    end

  end
end
