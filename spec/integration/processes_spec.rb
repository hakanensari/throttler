require "benchmark"
require "fileutils"
require "spec_helper"


describe "Throttler" do
  before do
    FileUtils.rm "/tmp/.foo", :force => true
  end

  it "throttles concurrent processes" do
    startup_time = Benchmark.realtime do
      `ruby #{File.dirname(__FILE__) + "/../fixtures/foo.rb"} control`
    end

    time = Benchmark.realtime do
      4.times{ `ruby #{File.dirname(__FILE__) + "/../fixtures/foo.rb"}` }
    end

    (time - startup_time).should be_within(0.5).of(6.0)
  end
end
