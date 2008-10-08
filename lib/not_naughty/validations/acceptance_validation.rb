module NotNaughty

  # == Validates acceptance of obj's attribute against a fixed value via <tt>:eql?</tt> call.
  #
  # Unless the validation succeeds an error hash (:attribute => :message)
  # is added to the obj's instance of Errors.
  #
  # <b>Options:</b>
  # <tt>:accept</tt>::  object to check against (via :eql?)
  # <tt>:message</tt>:: see NotNaughty::Errors for details
  # <tt>:if</tt>::      see NotNaughty::Validation::Condition for details
  # <tt>:unless</tt>::  see NotNaughty::Validation::Condition for details
  #
  # <b>Example:</b>
  #
  #   invalid = 'abc'
  #   valid = '1'
  #   def invalid.errors() @errors ||= NotNauthy::Errors.new end
  #   def valid.errors() @errors ||= NotNauthy::Errors.new end
  #
  #   AcceptanceValidation.new({}, :to_s).call invalid, :to_s, 'abc'
  #   invalid.errors.on(:to_s).any? # => true
  #
  #   AcceptanceValidation.new({}, :to_s).call valid, :to_s, '1'
  #   valid.errors.on(:to_s).any? # => false
  class AcceptanceValidation < Validation

    def initialize(opts, attributes) #:nodoc:
      __message, __accept =
        opts[:message] || '#{"%s".humanize} not accepted.',
        opts[:accept] || '1'

      if opts[:allow_blank] or opts.fetch(:allow_nil, true)
        __allow = if opts[:allow_blank] then :blank? else :nil? end
        super opts, attributes do |o, a, v|
          o.errors.add a, __message unless v.send __allow or __accept.eql? v
        end
      else
        super opts, attributes do |o, a, v|
          o.errors.add a, __message unless __accept.eql? v
        end
      end
    end

  end
end
