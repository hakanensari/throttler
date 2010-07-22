# Ripped from Cucumber

def stdout
  @stdout
end

def ruby_19?
  RUBY_VERSION =~ /^1\.9/
end

def run(command)
  mode = ruby_19? ? {:external_encoding=>"UTF-8"} : 'r'

  Dir.chdir(File.dirname(__FILE__) + "/../bin") do
    IO.popen("ruby #{command}.rb", mode) do |io|
      @stdout = io.read
    end
  end
end
