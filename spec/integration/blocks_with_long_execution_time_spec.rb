require "fileutils"
require "spec_helper"

describe "Throttler" do
  before do
    class Foo
      include Throttler

      def bar
        throttle("foo") do
          yield # so we can count
          sleep 10
        end
      end
    end

    FileUtils.rm "/tmp/.foo", :force => true
  end

  it "throttles threads with long execution times" do
    count = 0

    threads = 10.times.collect do
      Thread.new do
        loop{ Foo.new.bar{ count += 1 } }
      end
    end
    sleep 3.25
    threads.each { |t| Thread.kill(t) }

    count.should eql 4
  end
end
