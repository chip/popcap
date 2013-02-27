require 'pop_cap/commander'
require 'pop_cap/converter'
require 'pop_cap/fileable'
require 'pop_cap/ffmpeg/tag_writer'

module PopCap
  MissingDependency = Class.new(Errno::ENOENT)
  # Internal: This is a wrapper for the FFmpeg C library.
  #
  # Examples
  #
  #   filepath = 'spec/support/sample.flac'
  #   ffmpeg = FFmpeg.new(filepath)
  #
  class FFmpeg
    include Converter
    include Fileable

    attr_accessor :filepath

    # Internal: initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    #
    def initialize(filepath, commander=Commander)
      check_for_ffmpeg_install
      @filepath = filepath
      @commander = commander
    end

    # Internal: convert
    # This command calls up to Converter@convert.
    #
    # format - A valid audio file format as string or symbol.
    # bitrate = A valid bit rate as string or symbol.
    #
    def convert(format, bitrate=192)
      conversion = super(format,bitrate)
      @commander.new(*conversion).execute
    end

    # Internal: read_tags
    # Returns the raw output of FFProbe's show_format option.
    #
    # Examples
    #
    #    [FORMAT]
    #    filename=spec/support/sample.flac
    #    nb_streams=1
    #    format_name=flac
    #    format_long_name=raw FLAC
    #    start_time=N/A
    #    duration=1.000000
    #    size=18291
    #    bit_rate=146328
    #    TAG:GENRE=Sample Genre
    #    TAG:track=01
    #    TAG:ALBUM=Sample Album
    #    TAG:DATE=2012
    #    TAG:TITLE=Sample Title
    #    TAG:ARTIST=Sample Artist
    #    [/FORMAT]
    #
    def read_tags
      @stdout ||= encode(read_output)
    end

    # Public: update_tags(updates)
    # This wraps FFmpeg's -metadata command.
    #
    # Examples
    #   filepath = 'spec/support/sample.flac'
    #   ffmpeg = FFmpeg.new(filepath)
    #   ffmpeg.update_tags({artist: 'New Artist'})
    #
    def update_tags(updates, writer=TagWriter)
      writer.write(filepath, updates)
    end

    private
    def check_for_ffmpeg_install
      begin
        Open3.capture3('ffmpeg')
      rescue Errno::ENOENT
        raise MissingDependency, 'FFmpeg is not installed.'
      end
    end

    def encode(string)
      return string if string.valid_encoding?
      remove_invalid_bytes(string)
    end

    def remove_invalid_bytes(string)
      @string = string
      original_encoding = @string.encoding.name
      @string.encode!('UTF-16', original_encoding, undef:
                     :replace, invalid: :replace)
      @string.encode!('UTF-8')
    end

    def read_command
      %W{ffprobe -show_format} + %W{#{filepath}}
    end

    def read_output
      executed = @commander.new(*read_command).execute
      raise(FFmpegError, read_error_message) unless executed.success?
      executed.stdout
    end

    def read_error_message
      "Error reading #{self.filepath}"
    end
  end
end

FFmpegError = Class.new(StandardError)
