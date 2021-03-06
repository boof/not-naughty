require 'rubygems'
require 'spec'

require "#{ File.dirname __FILE__ }/../lib/not_naughty.rb"
NotNaughty::Validation.load 'format', 'presence'

def subject() ::NotNaughty end
def h(something)
  puts '<pre>%s</pre>' %
  something.inspect.gsub(/[<>]/) {|m| (m == '<')? '&lt;': '&gt;'}
end
