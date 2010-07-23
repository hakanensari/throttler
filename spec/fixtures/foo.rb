require File.dirname(__FILE__) + "/../../lib/throttler"

class Foo
  include Throttler

  def bar
    throttle("bar") { noop }
  end
  
  def noop; end
end

Foo.new.bar
