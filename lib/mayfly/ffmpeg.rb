require 'mayfly/commander'

module Mayfly

  # Internal: This is a wrapper for the FFmpeg C library.
  #
  # Examples
  #
  #   filepath = 'spec/support/sample.flac'
  #   ffmpeg = FFmpeg.new(filepath)
  #
  class FFmpeg

    # Internal: initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    #
    def initialize(filepath)
      @filepath = filepath
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
      @stdout ||= Commander.new(*read_command).execute.stdout
    end

    private
    def read_command
      %W{ffprobe -show_format} + %W{#{@filepath}}
    end
  end
end