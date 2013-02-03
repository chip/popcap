require 'mayfly/commander'
require 'mayfly/converter'
require 'mayfly/fileable'

module Mayfly
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

    attr_reader :filepath

    # Internal: initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    #
    def initialize(filepath)
      @filepath = filepath
    end

    # Internal: convert
    # This command calls up to Converter@convert.
    #
    # format - A valid audio file format as string or symbol.
    # bitrate = A valid bit rate as string or symbol.
    #
    def convert(format, bitrate=192)
      conversion = super(format,bitrate)
      Commander.new(*conversion).execute
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

    # Internal: update_tags(updates)
    # This wraps FFmpeg's -metadata command.
    #
    # Examples
    #   filepath = 'spec/support/sample.flac'
    #   ffmpeg = FFmpeg.new(filepath)
    #   ffmpeg.update_tags({artist: 'New Artist'})
    #
    def update_tags(updates)
      @updates = updates
      Commander.new(*write_command).execute
      self.restore('/tmp')
    end

    private
    def read_command
      %W{ffprobe -show_format} + %W{#{filepath}}
    end

    def write_command
      %W{ffmpeg -i #{filepath}} + write_options + %W{#{self.tmppath}}
    end

    def write_options
      @updates.inject(%W{}) do |options,update|
        options << '-metadata' << update.join('=')
      end
    end
  end
end
