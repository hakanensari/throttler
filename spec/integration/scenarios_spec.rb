require "benchmark"
require "fileutils"
require "spec_helper"

class Bar
  include Throttler

  def bar
    throttle("bar"){ noop }
  end

  def baz
    throttle("baz"){ noop }
  end

  def exceptional
    throttle("bar"){ raise }
  end

  def noop; end
end

describe "Simple integration tests" do
  before do
    FileUtils.rm "/tmp/.bar", :force => true
    FileUtils.rm "/tmp/.baz", :force => true
  end

  it "throttles a loop" do
    time = Benchmark.realtime do
      3.times do
        Bar.new.bar
      end
    end

    time.should be_close 2, 0.1
  end

  it "throttles threads" do
    count = 0
    threads = 10.times.collect do
      Thread.new do
        bar = Bar.new
        loop do
          bar.bar
          count += 1
        end
      end
    end
    sleep 2.2
    threads.each { |t| Thread.kill(t) }

    count.should eql 3
  end

  it "throttles fibers" do
    require "fiber"

    time = Benchmark.realtime do
      fib = Fiber.new do
        bar = Bar.new
        loop do
          bar.bar
          Fiber.yield
        end
      end

      3.times { fib.resume }
    end

    time.should be_close 2, 0.01
  end

  it "throttles concurrently-running scripts" do
    time = Benchmark.realtime do
      3.times do
        `ruby #{File.dirname(__FILE__) + "/../fixtures/foo.rb"}`
      end
    end

    time.should be > 4.0
  end

  it "supports multiple throttles" do
    count = 0
    threads = 10.times.collect do
      Thread.new do
        bar = Bar.new
        loop do
          count % 2 == 0 ? bar.bar : bar.baz
          count += 1
        end
      end
    end
    sleep 2.2
    threads.each { |t| Thread.kill(t) }

    count.should eql 6
  end
end
