require 'throttler/throttle'

# Throttler rate-limits code execution.
module Throttler
  class << self
    # Ensures subsequent code, including any given block, is executed at most per
    # every `wait` seconds.
    #
    # Optionally takes a splat of words to namespace the throttle.
    def limit(wait, *words)
      words << 'default' if words.empty?

      begin
        throttle = Throttle.new namespace(words)
        throttle.strangle
        throttle.hold wait
      ensure
        throttle.release
      end

      # Syntactic sugar.
      yield if block_given?
    end

    def namespace(words)
      words.compact.join '-'
    end
  end
end
