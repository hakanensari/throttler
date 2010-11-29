Throttler
=========

Throttler is a tired, cranky module that helps you throttle stuff in parallel-running Ruby scripts on a single machine.

![Mapplethorpe](https://github.com/papercavalier/throttler/raw/master/mapplethorpe_chains.jpg)

Example
-------

Our very own use case: We have multiple Resque workers hitting the Amazon IP on multiple addresses and want to make sure they don't fire more than once per locale per IP.

Here's some pseudo code:

    class Worker
      include Throttler

      def perform(*args)
        scope = "#{locale}-#{interface}"
        freq  = 1.0

        throttle(scope, freq) do
          # perform a request
        end
      end
    end
