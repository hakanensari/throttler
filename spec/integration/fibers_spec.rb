require "benchmark"
require "fiber"
require "fileutils"
require "spec_helper"

describe "Throttler" do
  before do
    class Foo
      include Throttler

      def bar
        throttle { }
      end
    end

    FileUtils.rm "/tmp/.throttler", :force => true
  end

  it "throttles fibers" do
    time = Benchmark.realtime do
      fib = Fiber.new do
        loop{ Foo.new.bar; Fiber.yield }
      end
      3.times { fib.resume }
    end

    time.should be_within(0.1).of(2)
  end
end
