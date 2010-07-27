require "benchmark"
require "fileutils"
require "spec_helper"

describe Throttler do
  before do
    class Foo
      include Throttler

      def bar
        throttle("foo"){ raise }
      end
    end

    FileUtils.rm "/tmp/.foo", :force => true

    @foo = Foo.new
  end

  context "#throttle" do
    it "removes lock even if block raises an exception" do
      lambda{ @foo.throttle("foo"){ raise } }.should raise_error

      File.open("/tmp/.foo"){ |f| f.flock(File::LOCK_EX | File::LOCK_NB).should_not be_false }
    end

    it "throttles for one second by default" do
      time = Benchmark.realtime do
        2.times{ @foo.throttle("foo"){ } }
      end

      time.should be_close 1, 0.1
    end
  end  
end
