$:.push File.expand_path("../../../lib", __FILE__)
require "throttler"

class Foo
  include Throttler

  def bar
    throttle("foo", 2.0) { }
  end

  def control; end
end

if ARGV.size == 0
  Foo.new.bar
else
  Foo.new.control
end
