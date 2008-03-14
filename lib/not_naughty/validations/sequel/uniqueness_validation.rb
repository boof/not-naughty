module NotNaughty
  
  class UniquenessValidation < Validation
    
    def initialize(opts, attributes) #:nodoc:
      __message = opts[:message] || '#{"%s".humanize} is not unique.'
      
      if opts[:allow_blank] or opts[:allow_nil]
        __allow = if opts[:allow_blank] then :blank? else :nil? end
        super opts, attributes do |obj, attr, val|
          obj.errors.add attr, __message unless
            v.send! __allow or
            obj.model.find(attr => val).limit(1).length.zero?
        end
      else
        super opts, attributes do |obj, attr, val|
          obj.errors.add attr, __message unless
            obj.model.find(attr => val).limit(1).length.zero?
        end
      end
    end
    
  end
end
