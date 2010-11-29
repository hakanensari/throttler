require "throttler/timer"

# = Throttler
#
# A tired, cranky module that helps you throttle stuff in parallel-running Ruby
# scripts on a single machine. It gets the job done.
module Throttler
  def throttle(scope="throttler",freq=1.0)
    timer = Timer.new(scope)
    timer.lock
    sleep [timer.timestamp + freq - Time.now.to_f, 0.0].max
    timer.timestamp = Time.now.to_f
    timer.unlock
    yield if block_given?
  end
end
