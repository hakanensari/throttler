require "benchmark"
require "fileutils"
require "spec_helper"

class Foo
  include Throttler

  def bar
    throttle("foo"){ raise }
  end
end

describe Throttler do
  before do
    FileUtils.rm "/tmp/.foo", :force => true
    
    class Foo; include Throttler; end
    @foo = Foo.new
  end

  context "#throttle" do
    it "removes lock after block raises an exception" do
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
