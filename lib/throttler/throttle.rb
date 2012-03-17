module Throttler
  class Throttle
    class << self
      attr_accessor :tmp_dir
    end

    @tmp_dir = '/tmp'

    def initialize(namespace)
      @namespace = namespace
    end

    def hold(wait)
      sleep [timestamp + wait - now, 0.0].max
      timestamp!
    end

    def release
      @file.flock File::LOCK_UN
      @file.close
    end

    def strangle
      file.flock File::LOCK_EX
    end

    private

    def file
      @file ||= File.open path, File::RDWR|File::CREAT
    end

    def now
      Time.now.to_f
    end

    def path
      "#{self.class.tmp_dir}/.lock-#{@namespace}"
    end

    def timestamp
      file.rewind
      file.gets.to_f
    end

    def timestamp!
      file.rewind
      file.write now
    end
  end
end
