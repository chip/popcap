require 'pop_cap/ffmpeg/commander'

module PopCap
  class AnalyzeFile
    attr_reader :filepath

    def initialize(filepath)
      @filepath = File.expand_path(filepath)
    end

    def examine
      [datetimestamp, error]
    end

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
      "FFprobe read error on #{Time.now.strftime("%Y-%m-%d at %H:%M:%S")}"
    end

    def error
      contents.split("\n").last
    end
  end
end
