module Throttler
  class Timer
    def initialize(scope)
      path = "/tmp/.#{scope}"
      @file = File.open(path, File::RDWR|File::CREAT)
    end

    def lock
      @file.flock(File::LOCK_EX)
    end

    def timestamp
      @timestamp ||= @file.gets.to_f
    end

    def timestamp=(time)
      @file.rewind
      @file.write(time)
      @timestamp = time
    end

    def unlock
      @file.flock(File::LOCK_UN)
      @file.close
    end
  end
end
