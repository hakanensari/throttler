require "spec_helper"
require "benchmark"
require "fileutils"

module Throttler
  describe Throttle do
    before do
      FileUtils.rm "/tmp/.foo", :force => true
      @foo = Throttle.new("foo")
    end

    it "creates a file" do
      File.exists?("/tmp/.foo").should be_true
    end

    context "#lock" do
      it "locks the file" do
        @foo.lock
        File.open("/tmp/.foo") { |f| f.flock(File::LOCK_EX | File::LOCK_NB).should be_false }
      end
    end

    context "#delay" do
      it "throttles if file contains a timestamp" do
        file = @foo.instance_variable_get(:@file)
        file.stub!(:gets).and_return(Time.now.to_f)

        time = Benchmark.realtime do
          @foo.delay(1.0)
        end

        time.should be_close 1, 0.1
      end

      it "does not throttle if file is blank" do
        file = @foo.instance_variable_get(:@file)
        file.stub!(:gets).and_return("")

        time = Benchmark.realtime do
          @foo.delay(1.0)
        end

        time.should be_close 0, 0.1
      end
    end

    context "#timestamp" do
      it "timestamps file" do
        @foo.timestamp
        file = @foo.instance_variable_get(:@file)
        file.close # We need to close the file first

        File.open("/tmp/.foo") { |f| f.gets.to_f.should be_close Time.now.to_f, 0.1 }
      end
    end

    context "#unlock" do
      it "unlocks the file" do
        @foo.lock
        @foo.unlock

        File.open("/tmp/.foo") { |f| f.flock(File::LOCK_EX | File::LOCK_NB).should_not be_false }
      end
    end
  end
end
