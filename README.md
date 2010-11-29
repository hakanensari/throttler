Throttler
=========

Throttler is a tired, cranky module that throttles parallel-running Ruby scripts on a single machine.

![Mapplethorpe](https://github.com/papercavalier/throttler/raw/master/mapplethorpe_chains.jpg)

Example
-------

Our very own peculiar use case: We have multiple Resque workers hitting the Amazon IP on multiple addresses and want to make sure they don't fire more than once per locale per IP.

    class Worker
      include Throttler

      attr_accessor :locale,
                    :interface

      def perform
        scope = "#{locale}-#{interface}"
        freq  = 1.0

        throttle(scope, interval) do
          # perform a request
        end
      end
    end
