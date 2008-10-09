module NotNaughty

  # == Validates length of obj's attribute via the <tt>:length</tt> method.
  #
  # Unless the validation succeeds an error hash (:attribute => :message)
  # is added to the obj's instance of Errors.
  #
  # <b>Options:</b>
  # <tt>:message</tt>:: see NotNaughty::Errors for details
  # <tt>:if</tt>::      see NotNaughty::Validation::Condition for details
  # <tt>:unless</tt>::  see NotNaughty::Validation::Condition for details
  #
  # <b>Boundaries (by precendence):</b>
  # <tt>:is</tt>::      valid length
  # <tt>:within</tt>::  valid range of length
  # <tt>:minimum</tt>:: maximum length
  # <tt>:maximum</tt>:: minimum length
  #
  # If both, <tt>:minimum</tt> and <tt>:maximum</tt> are provided they're
  # converted to :within.  Each boundary type has its own default message:
  # precise:: "Length of %s is not equal to #{__length}."
  # range:: "Length of %s is not within #{__range.first} and #{__range.last}."
  # lower:: "Length of %s is smaller than #{__boundary}."
  # upper:: "Length of %s is greater than #{__boundary}."
  #
  # <b>Example:</b>
  #
  #   obj = %w[a sentence with five words] #
  #   def obj.errors() @errors ||= NotNauthy::Errors.new end
  #
  #   LengthValidation.new({:minimum => 4}, :to_a).
  #     call obj, :to_a, %w[a sentence with five words]
  #   obj.errors.on(:to_s).any? # => false
  #
  #   LengthValidation.new({:within => 1..4}, :to_a).
  #     call obj, :to_a, %w[a sentence with five words]
  #   obj.errors.on(:to_s).any? # => true
  #
  # I'm sorry for using eval here...
  class LengthValidation < Validation

TEMPLATE = <<-BLOCK
proc do |obj, attr, value|
  value.%s or %s value.length or
  obj.errors.add attr, %s
end
BLOCK

    def initialize(valid, attributes) #:nodoc:
      super valid, attributes, &build_block(valid)
    end

    protected
    def build_block(valid) #:nodoc:
      if valid[:is] then is_block valid
      elsif valid[:within] or valid[:minimum] && valid[:maximum] then within_block valid
      elsif valid[:minimum] then minimum_block valid
      elsif valid[:maximum] then maximum_block valid
      else
        raise ArgumentError, 'no boundary given'
      end
    end

    def is_block(valid)
      valid[:message] ||= "Length of %s is not equal to #{ valid[:is] }."

      eval TEMPLATE % [ valid[:allow_blank] ? :blank? : :nil?,
        "#{ valid[:is].inspect } ==", valid[:message].inspect ]
    end
    def within_block(valid)
      valid[:within] ||= Range.new valid[:minimum], valid[:maximum]
      valid[:message] ||= "Length of %s is not within #{ valid[:within].min } and #{ valid[:within].max }."

      eval TEMPLATE % [ valid[:allow_blank] ? :blank? : :nil?,
        "(#{ valid[:within].inspect }).include?", valid[:message].inspect ]
    end
    def minimum_block(valid)
      valid[:message] ||= "Length of %s is less than #{ valid[:minimum] }."

      eval TEMPLATE % [ valid[:allow_blank] ? :blank? : :nil?,
        "#{ valid[:minimum].inspect } <=", valid[:message].inspect ]
    end
    def maximum_block(valid)
      valid[:message] ||= "Length of %s is greater than #{ valid[:maximum] }."

      eval TEMPLATE % [ valid[:allow_blank] ? :blank? : :nil?,
        "#{ valid[:maximum].inspect } >=", valid[:message].inspect ]
    end

  end
end
