def duration
  timestamps = stdout.split.collect(&:to_i).sort
  timestamps.last - timestamps.first
end
