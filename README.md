Throttler
=========

![Mapplethorpe](http://github.com/papercavalier/throttler/raw/master/mapplethorpe_chains.jpg)

Throttler throttles concurrency.

    class Foo
      include Throttler

      def request
        throttle("foo#{interface}", 1.0) do
          #noop
        end
      end

      def interface
        "eth0"
      end
    end

    foo = Foo.new
    
    100.times do
      Thread.new do
        foo.request
        count += 1
      end
    end
    sleep 1.2
    count.should eql 2
    sleep 1.2
    count.should eql 3

Use case
--------

Imagine multiple workers hitting the Amazon API on the same IP address. You gotta do something about it.
