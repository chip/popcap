require 'pop_cap/ffmpeg/commander'

module PopCap
  # Public: This class is similar to TagReader, but is useful for debugging.
  # If a file cannot be read, this will return the error message generated
  # by FFprobe
  #
  class AnalyzeFile
    attr_reader :filepath

    # Public: Initialize an instance of AnalyzeFile.
    # filepath = relative path to a file on the filesystem
    #
    def initialize(filepath)
      @filepath = File.expand_path(filepath)
      @datetime = Time.now.strftime("%Y-%m-%d at %H:%M:%S")
    end

    # Public: This method returns the stderr of FFprobe -show_format
    # as an array.  The first element is a datetime stamp, the second
    # element is the error message.
    #
    def examine
      [datetimestamp, error]
    end

    # Public: A convenience class method for examining a file.
    #
    def self.examine(filepath)
      new(filepath).examine
    end

    private
    def command
      %W{ffprobe -show_format -print_format json} + %W{#{filepath}}
    end

    def contents
      Commander.new(*command).execute.stderr
    end

    def datetimestamp
      "FFprobe read error on #{@datetime}"
    end

    def error
      contents.split("\n").last
    end
  end
end
