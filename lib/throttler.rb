require File.dirname(__FILE__) + "/throttler/throttle"
require File.dirname(__FILE__) + "/throttler/timer"

# The Throttler module.
#
# Simply include this in the class where you wish to use the throttler.
module Throttler

  # Throttles execution of a block of code.
  #
  # Pass name of throttler and optionally, the interval between each
  # moment of execution. Latte defaults to one second.
  #
  #    throttle("foo") { some_code }
  #
  def throttle(name, interval=1.0)
    timer = Timer.new(name)
    timer.lock
    begin
      sleep [timer.timestamp + interval - Time.now.to_f, 0.0].max
      yield if block_given?
      timer.timestamp = Time.now.to_f
    ensure
      timer.unlock
    end
  end
end
