require File.dirname(__FILE__) + "/throttler/throttle"

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
    begin
      file = Throttle.new(name)
      file.lock
      file.delay interval
      yield if block_given?
      file.timestamp
    ensure
      file.unlock
    end
  end
end
