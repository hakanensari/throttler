require "benchmark"
require "fileutils"
require "spec_helper"

class Foo
  include Throttler

  def bar
    throttle("bar"){ noop }
  end

  def baz
    throttle("baz"){ noop }
  end

  def noop; end
end

describe Throttler do
  before do
    FileUtils.rm "/tmp/.bar", :force => true
    FileUtils.rm "/tmp/.baz", :force => true
  end

  it "throttles a loop" do
    time = Benchmark.realtime do
      3.times do
        Foo.new.bar
      end
    end

    time.should be_close 2, 0.01
  end

  it "throttles threads" do
    count = 0
    threads = 10.times.collect do
      Thread.new do
        foo = Foo.new
        loop do
          foo.bar
          count += 1
        end
      end
    end
    sleep 2.2
    threads.each { |t| Thread.kill(t) }

    count.should eql 3
  end

  it "throttles concurrently-running scripts" do
    time = Benchmark.realtime do
      3.times do
        `ruby #{File.dirname(__FILE__) + "/fixtures/foo.rb"}`
      end
    end

    time.should be > 2.0
  end

  it "throttles by name" do
    count = 0
    threads = 10.times.collect do
      Thread.new do
        foo = Foo.new
        loop do
          count % 2 == 0 ? foo.bar : foo.baz
          count += 1
        end
      end
    end
    sleep 2.2
    threads.each { |t| Thread.kill(t) }

    count.should eql 6
  end
end
