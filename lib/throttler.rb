require File.dirname(__FILE__) + "/throttler/timer"

# The Throttler module.
#
# Include this in the class where you wish to use the throttler.
module Throttler

  # Throttles the frequency in which a block is run.
  #
  # Pass throttler scope and the interval between each execution.
  # Latter defaults to one second.
  #
  #    throttle("foo") { some_code }
  #
  def throttle(scope, interval=1.0)
    timer = Timer.new(scope)
    timer.lock
    sleep [timer.timestamp + interval - Time.now.to_f, 0.0].max
    timer.timestamp = Time.now.to_f
    timer.unlock
    yield if block_given?
  end
end
