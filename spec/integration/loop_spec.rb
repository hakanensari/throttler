require "benchmark"
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

  it "throttles a loop" do
    time = Benchmark.realtime do
      3.times do
        Foo.new.bar
      end
    end

    time.should be_within(0.1).of(2)
  end
end
