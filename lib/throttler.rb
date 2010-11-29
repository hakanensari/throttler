require "throttler/timer"

# = Throttler
#
# An old, rusty throttler that gets the job done
module Throttler

  # Throttles the frequency in which a block is run
  #
  # Optionally pass a scope and interval.
  def throttle(scope="throttler", interval=1.0)
    timer = Timer.new(scope)
    timer.lock
    sleep [timer.timestamp + interval - Time.now.to_f, 0.0].max
    timer.timestamp = Time.now.to_f
    timer.unlock
    yield if block_given?
  end
end
