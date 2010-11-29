require "benchmark"
require "fileutils"
require "spec_helper"

describe Throttler do
  before do
    class Foo
      include Throttler
    end

    FileUtils.rm "/tmp/.throttler", :force => true
  end

  let!(:foo) do
    Foo.new
  end

  describe "#throttle" do
    it "removes a lock when an exception is raised" do
      expect do
        foo.throttle { raise }
      end.to raise_error

      File.open("/tmp/.throttler") do |f|
        f.flock(File::LOCK_EX | File::LOCK_NB).should_not be_false
      end
    end

    context "by default" do
      it "namespaces as `throttler`" do
        foo.throttle
        FileTest.exists?("/tmp/.throttler").should be_true
      end

      it "throttles for one second" do
        time = Benchmark.realtime do
          2.times{ foo.throttle }
        end

        time.should be_within(0.1).of(1)
      end
    end
  end
end
