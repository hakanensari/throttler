require "spec_helper"

describe Throttler do
  it "should create a lock file" do
   #lock = @throttle.send :file_path
   #File.file?(@throttle.send(:file_path)).should be_true
  end

  context "loop" do
    it "throttles" do
      run "simple_loop"

      duration.should eql 10
    end
  end
    # 
    # 
    # 
    # it "should get the timestamp" do
    #   File.open(@throttle.send(:file_path), "r") { |f| f.gets }.should match /^[0-9.]+$/
    # end
    # 
    # it "should check in" do
    #   
    # end
end
