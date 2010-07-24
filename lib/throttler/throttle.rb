module Throttler

  # The Throttle file
  class Throttle
    def initialize(name)
      path = "/tmp/.#{name}"
      @file = File.open(path, File::RDWR|File::CREAT)
    end

    def delay(interval)
      last = @file.gets.to_f
      last = (Time.now.to_f - interval) if last == 0.0

      sleep [last + interval - Time.now.to_f, 0.0].max
    end

    def lock
      @file.flock(File::LOCK_EX)
    end

    def timestamp
      @file.rewind
      @file.write(Time.now.to_f)
    end

    def unlock
      @file.flock(File::LOCK_UN)
      @file.close
    end
  end
end
