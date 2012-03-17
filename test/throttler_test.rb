require 'test/unit'
require 'benchmark'
require 'throttler'

class Work
  def self.perform
    Throttler.limit 0.1
  end
end

class WorkAsWell
  def self.perform
    Throttler.limit 0.1, 'foo'
  end
end

class ThrottlerTest < Test::Unit::TestCase
  def test_throttling
    time = Benchmark.realtime do
      11.times { Process.fork { Work.perform } }
      Process.waitall
    end
    assert_equal 1, time.to_i
  end

  def test_namespace
    time = Benchmark.realtime do
      11.times do
        Process.fork { Work.perform }
        Process.fork { WorkAsWell.perform }
      end
      Process.waitall
    end
    assert_equal 1, time.to_i
  end
end
