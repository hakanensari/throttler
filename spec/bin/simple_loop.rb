require File.dirname(__FILE__) + "/../../lib/throttler"

class Foo
  def timestamp
    throttle<< { puts Time.now.to_f }
  end

  def throttle
    @throttle ||= Throttler.new
  end
end

10.times { Foo.new.timestamp }
