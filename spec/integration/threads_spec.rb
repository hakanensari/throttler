require "fileutils"
require "spec_helper"

describe "Throttler" do
  before do
    class Foo
      include Throttler

      def bar
        throttle { }
      end

      def baz
        throttle("foo-prime"){ }
      end
    end

    %w{throttler foo-prime}.each do |file|
      FileUtils.rm "/tmp/.#{file}", :force => true
    end
  end

  it "throttles threads" do
    count = 0
    threads = 10.times.collect do
      Thread.new do
        loop { Foo.new.bar; count += 1 }
      end
    end
    sleep 3.25
    threads.each { |t| Thread.kill(t) }

    count.should eql 4
  end

  it "throttles by scope" do
    count = 0
    threads = 10.times.collect do
      Thread.new do
        loop do
          Foo.new.send(count % 2 == 0 ? :bar : :baz)
          count += 1
        end
      end
    end
    sleep 3.25
    threads.each { |t| Thread.kill(t) }

    count.should eql 8
  end
end
