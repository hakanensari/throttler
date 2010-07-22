module Throttler
  class Throttle
    def initialize(name)
      @name = name
      unless File.file?(file_path)
        File.open(file_path, "w") { |f| f.write(timestamp) } 
      end
    end

    def check_in
      file = File.open(file_path, "r+") { |f| f.gets }
      if file && file.flock(File::LOCK_EX)
        f.rewind
        f.write(timestamp)
        true
      else
        false
      end
    end

    private

    def file_path
      @file_path ||= "/tmp/#{@name}-throttle.tmp"
    end

    def timestamp
      Time.now.to_f
    end
  end
end
