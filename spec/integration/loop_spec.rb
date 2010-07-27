require "benchmark"
require "fileutils"
require "spec_helper"

describe "Throttler" do
  before do
    class Foo
      include Throttler

      def bar
        throttle("foo"){ }
      end
    end

    FileUtils.rm "/tmp/.foo", :force => true
  end

  it "throttles a loop" do
    time = Benchmark.realtime do
      3.times do
        Foo.new.bar
      end
    end

    time.should be_close 2, 0.1
  end
end
