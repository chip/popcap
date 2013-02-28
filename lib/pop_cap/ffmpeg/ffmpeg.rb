require 'pop_cap/ffmpeg/converter'
require 'pop_cap/ffmpeg/tag_reader'
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
    attr_accessor :filepath

    # Internal: initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    #
    def initialize(filepath)
      check_for_ffmpeg_install
      @filepath = filepath
    end

    # Public: This comverts a file to the specified output format
    # & optional bitrate.
    #
    # format - A valid audio file format as string or symbol.
    # bitrate = A valid bit rate as string or symbol.
    # converter = Optional.  The converter library to use.
    #
    def convert(format, bitrate=192, converter=Converter)
      converter.convert(filepath, {format: format, bitrate: bitrate})
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
    def read_tags(reader=TagReader)
      reader.read(filepath)
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
  end
end
