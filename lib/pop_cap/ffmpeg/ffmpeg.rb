require 'pop_cap/ffmpeg/commander'

module PopCap
  FFmpegError = Class.new(StandardError)
  MissingDependency = Class.new(Errno::ENOENT)

  # Public: This is a wrapper for the FFmpeg C library.
  #
  # Examples
  #
  #   file = 'spec/fixtures/sample.flac'
  #   ffmpeg = FFmpeg.new(filepath)
  #
  class FFmpeg
    attr_accessor :commander, :filepath, :options

    # Public: initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    # commander - Defaults to Commander for executing system commands.
    #
    def initialize(filepath, options={})
      check_for_ffmpeg_install
      @filepath, @options = filepath, options
      @commander = options[:commander] || Commander
    end

    # Public: error_message
    #
    # message - Provide the message to return.
    #
    def error_message(message)
      "Error #{message} #{filepath}."
    end

    # Public: execute a command
    #
    def execute
      @executed ||= commander.new(*command).execute
    end

    private
    def check_for_ffmpeg_install
      begin
        Open3.capture3('ffmpeg')
      rescue Errno::ENOENT
        raise MissingDependency, 'FFmpeg is not installed.'
      end
    end
  end
end
