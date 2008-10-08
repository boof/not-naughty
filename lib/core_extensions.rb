class Array #:nodoc:
  instance_methods.include? 'extract_options!' or
  define_method(:extract_options!) { Hash === last ? pop : {} }
end
class Object #:nodoc:
  instance_methods.include? 'blank?' or
  define_method(:blank?) { respond_to?(:empty?) ? empty? : !self }
end
class String #:nodoc:
  instance_methods.include? 'blank?' or
  define_method(:blank?) { self !~ /\S/ }
end
class Numeric #:nodoc:
  instance_methods.include? 'blank?' or
  define_method(:blank?) { false }
end

def nil.blank?() true end unless nil.respond_to? :blank?
def true.blank?() false end unless true.respond_to? :blank?
def false.blank?() true end unless false.respond_to? :blank?
