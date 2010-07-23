Throttler
=========

![Mapplethorpe](http://github.com/papercavalier/throttler/raw/master/mapplethorpe_chains.jpg)

Throttle concurrency.

    include Throttler
    
    100.times do
      Thread.new do
        loop do
          throttle("foo") do
            count += 1
          end
        end
      end
    end
    sleep 2.2
    
    count.should eql 3

Use case
--------

Imagine multiple workers hitting the Amazon API on the same IP address. You gotta do something about it.
