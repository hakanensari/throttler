Throttler
=========

Put a throttle on concurrency.

![Mapplethorpe](http://github.com/papercavalier/throttler/raw/master/mapplethorpe_chains.jpg)

Example
--------

Let's assume we have multiple workers hitting the Amazon API on three IP addresses.

    class Worker
      include Throttler
      
      attr_accessor :interface
      
      def request
        
        # Scope the throttle by network interface:
        name      = "foo#{interface}"
        
        # Amazon asks you to limit requests to one per second per IP, so:
        interval  = 0.9
        
        # Say a request downloads in two seconds on average
        throttle(name, interval) { sleep(2) }
      end
    end
    
    worker, count = Worker.new, 0
    
    (0..3).each do |port|
      10.times do
        Thread.new do
          count += 1
          worker.interface = "eth#{port}"
          loop{ worker.request }
        end
      end
    end
    
    sleep 10.25
    
    # We expect workers to have sent 11 requests within 10 seconds on
    # each of the three available network interfaces.
    count.should eql(33)
