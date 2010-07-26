Throttler
=========

![Mapplethorpe](http://github.com/papercavalier/throttler/raw/master/mapplethorpe_chains.jpg)

Throttle concurrency.

    class Foo
      include Throttler

      def request
        throttle("foo#{interface}", 1.0) do
          # do something
        end
      end

      def interface; "eth0"; end
    end
    
    foo, count = Foo.new, 0
    
    100.times do
      Thread.new do
        foo.request
        count += 1
      end
    end
    
    sleep 1.2
    count.should eql(2)

Use case
--------

Imagine multiple workers hitting the Amazon API on the same IP address.
