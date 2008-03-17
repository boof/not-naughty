class Tree::TreeNode
  
  def closest(obj)
    if @name == obj then self
    elsif @name > obj
      closest = self
      @children.any? { |child| node = child.closest(obj) and closest = node }
      
      closest
    end
  end
  
end

module NotNaughty
  
  class ErrorHandler
    
    def initialize(handler = Kernel)
      @handles = Tree::TreeNode.new Exception, proc { |e| handler.raise e }
    end
    
    # Calls closest handle with exception.
    def raise(exception)
      handle = @handles.closest exception.class
      handle.content.call exception
    end
    
    # Inserts handle into the ordered tree.
    def handle(exception_class, &block)
      closest_handle = @handles.closest exception_class
      
      if closest_handle == exception_class then closest_handle.content = block
      else
        new_handle = Tree::TreeNode.new exception_class, block
        
        closest_handle.children do |child|
          exception_class > child.name and
          new_handle << closest_handle.remove!(child)
        end
        
        closest_handle << new_handle
      end
    end
    
  end
  
end
