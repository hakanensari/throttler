require 'throttler/throttle'

# Throttler rate-limits code execution.
module Throttler
  # Ensures subsequent code, including any given block, is executed at most per
  # every `wait` seconds.
  #
  # Optionally takes a splat of words to namespace the throttle.
  def self.limit(wait, *namespaces)
    namespaces << 'default' if namespaces.empty?

    begin
      throttle = Throttle.new namespaces.join '-'
      throttle.lock
      throttle.hold wait
    ensure
      throttle.unlock
    end

    yield if block_given?
  end
end
