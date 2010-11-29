module Throttler #:nodoc:
  class Timer
    def initialize(scope)
      path = "/tmp/.#{scope}"
      @timer = File.open(path, File::RDWR|File::CREAT)
    end

    def lock
      @timer.flock(File::LOCK_EX)
    end

    def timestamp
      @timestamp ||= @timer.gets.to_f
    end

    def timestamp=(time)
      @timer.rewind
      @timer.write(time)
      @timestamp = time
    end

    def unlock
      @timer.flock(File::LOCK_UN)
      @timer.close
    end
  end
end
