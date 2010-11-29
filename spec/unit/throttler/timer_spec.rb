require "spec_helper"
require "benchmark"
require "fileutils"

module Throttler
  describe Timer do
    before do
      FileUtils.rm "/tmp/.foo", :force => true
    end

    let!(:timer) do
      Timer.new("foo")
    end

    it "creates a file" do
      File.exists?("/tmp/.foo").should be_true
    end

    context "#lock" do
      it "locks the file" do
        timer.lock
        File.open("/tmp/.foo") do |f|
          f.flock(File::LOCK_EX | File::LOCK_NB).should be_false
        end
      end
    end

    context "#timestamp" do
      it "gets the timestamp" do
        now = Time.now.to_f
        File.open("/tmp/.foo", "w") { |f| f.write(now) }
        timer.timestamp.should be_within(0.1).of(now)
      end

      it "returns 0.0 when file is first created" do
        timer.timestamp.should eql(0.0)
      end
    end

    context "#timestamp=" do
      it "sets the timestamp" do
        now = Time.now.to_f
        timer.timestamp= now

        # We need to close the file first
        timer.instance_variable_get(:@timer).close

        File.open("/tmp/.foo") do |f|
          f.gets.to_f.should be_within(0.1).of(now)
        end
      end
    end

    context "#unlock" do
      it "unlocks the file" do
        timer.lock
        timer.unlock

        File.open("/tmp/.foo") do |f|
          f.flock(File::LOCK_EX | File::LOCK_NB).should_not be_false
        end
      end
    end
  end
end
