# Throttler
module Throttler
  require "fileutils"

  def throttle(name, interval=1.0)
    begin
      path = "/tmp/.#{name}"

      FileUtils.touch path unless File.exist? path

      file = File.open(path, "r+")
      file.flock(File::LOCK_EX)
    
      last = file.gets.to_f || Time.now.to_f - interval
      sleep [last + interval - Time.now.to_f, 0.0].max

      yield if block_given?

      file.rewind
      file.write(Time.now.to_f)
    ensure
      file.flock(File::LOCK_UN)
      file.close
    end
  end
end
