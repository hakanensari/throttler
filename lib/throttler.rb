# Throttler
class Throttler
  attr_writer :name, :frequency, :timeout

  def sleep
    start = now

    while now - start < timeout
      if checked_in
        generate_timestamp
        yield if block_given?
        return true
      else
        sleep(current_timestamp + frequency - now)
      end
    end
    
    yield if block_given?
  end

  private

  def checked_in
    file && file.flock(File::LOCK_EX)
  end

  def file
    @file ||= read_file
  end

  def frequency
    @frequency ||= 1.0
  end

  def generate_timestamp
    file.rewind
    file.write(now)
  end

  def name
    @name ||= File.basename(__FILE__, ".rb").downcase
  end

  def now
    Time.now.to_f
  end

  def read_file
    file = File.expand_path(".#{name}.t", "/tmp")
    File.open(file, "r+") { |f| @current_timestamp = f.gets } 
  end

  def timeout
    @timeout ||= 60.0
  end


  # 
  # def check_out
  #   
  #   flock($this->_fp, LOCK_UN);
  #   fclose($this->_fp);
  #   return true;
  # }
  # 
  # 
  # 
  # def timestamp_file
  #   File.open(file_path, "r+") { |f| f.gets }
  # end

end
