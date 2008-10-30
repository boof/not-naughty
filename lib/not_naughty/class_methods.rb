module NotNaughty
  module ClassMethods

    def self.update(validation) # :nodoc:
      if basename = validation.name[/([^:]+)Validation$/, 1]
        define_method 'validates_%s_of' % basename.downcase do |*params|
          validator.add_validation(validation, *params)
        end
      end
    end

    # == Syntactic sugar.
    #
    # <b>Example:</b>
    #   validates { presence_of :example, :if => :reading? }
    #     # => validate_presence_of :example, :if => :reading?
    #   validates(:name) { presence and length :minimum => 6 }
    #     # => validates_presence_of :name
    #          validates_length_of :name, :minimum => 6
    #   validates(:temp, :if => water?) { value :lt => 100 }
    #     # => validates_value_of :temp, :lt => 100, :if => water?
    def validates(*params, &block)
      Builder.new(self, *params).instance_eval(&block)
    end

    # Allows adding validations the legacy way.
    def validates_each(*attributes, &block)
      validator.add_validation(*attributes, &block)
    end

    # With this you get syntactical sugar for all descendants of Validation
    # see validates for examples.
    class Builder

      def initialize(klass, *params) # :nodoc:
        @_vd_obj            = klass
        @_vd_obj_opts       = params.extract_options!
        @_vd_obj_attrs      = params

        methods = ClassMethods.instance_methods(false).grep(/^validates_.+_of$/)

        if @_vd_obj_attrs.empty?
          for method in methods
            eval <<-EOS
              def self.#{ method[/^validates_(.+)$/, 1] }(*params)
                params << @_vd_obj_opts.merge(params.extract_options!)

                begin
                  @_vd_obj.__send__(:#{ method }, *params)
                rescue Exception
                  $@.delete_if { |s| /^\\(eval\\):/ =~ s }
                  raise
                end
              end
            EOS
          end
        else
          for method in methods
            eval <<-EOS
              def self.#{ method[/^validates_(.+)_of$/, 1] }(*args)
                params = @_vd_obj_attrs.dup
                params << @_vd_obj_opts.merge(args.extract_options!)

                begin
                  @_vd_obj.__send__(:#{ method }, *params)
                rescue Exception
                  $@.delete_if { |s| /^\\(eval\\):/ =~ s }
                  raise
                end
              end
            EOS
          end
        end
      end
    end

  end
end
