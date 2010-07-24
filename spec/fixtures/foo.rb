require File.dirname(__FILE__) + "/../../lib/throttler"

class Foo
  include Throttler

  def bar
    throttle("bar", 2.0) do
      #noop
    end
  end
end

Foo.new.bar
