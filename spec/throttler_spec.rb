require File.join(File.dirname(__FILE__), "/spec_helper") 

class Foo
  include Throttler

  def bar
    10.times do
      throttle { timestamp }
    end
  end

  private

  def timestamp
    puts Time.now.strftime("%I:%M:%S")
  end
end

describe Throttler do
  before do
    @foo = Foo.new
  end

  it "throttles" do
    @foo.bar
  end
    # 
    # it "should create a lock file" do
    #   lock = @throttle.send :file_path
    #   File.file?(@throttle.send(:file_path)).should be_true
    # end
    # 
    # it "should get the timestamp" do
    #   File.open(@throttle.send(:file_path), "r") { |f| f.gets }.should match /^[0-9.]+$/
    # end
    # 
    # it "should check in" do
    #   
    # end
end
