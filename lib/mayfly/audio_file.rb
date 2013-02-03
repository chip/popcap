require 'mayfly/ffmpeg'
require 'mayfly/taggable'

module Mayfly
  # Public: This is a class for managing audio files on the filesystem.
  # It is used to read & write metadata tags, convert between audio formats,
  # and manage a file on the filesystem using standard UNIX file commands.
  #
  # Examples
  #
  #   filepath = 'spec/support/sample.flac'
  #   af = AudioFile.new(filepath)
  #
  #
  class AudioFile
    include Fileable
    include Taggable

    # Public: Initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    #
    def initialize(filepath)
      @filepath = filepath
    end

    # Public: convert
    # This method converts an audio file between formats.
    # It takes an optional bitrate for mp3 formats.
    #
    # format - A valid audio file format as string or symbol.
    # bitrate - An optional bitrate for mp3s.
    #
    # Examples
    #   audio_file = AudioFile.new('spec/support/sample.flac')
    #   audio_file.convert('mp3', 128)
    #   # => 'spec/support/sample.mp3'
    #
    def convert(format, bitrate=192)
      FFmpeg.new(@filepath).convert(format, bitrate)
    end

    # Public: raw_tags
    # This method returns the raw_tags from FFmpeg.
    #
    # Examples
    #   audio_file = AudioFile.new('spec/support/sample.flac')
    #   audio_file.raw_tags
    #   # =>
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
    def raw_tags
      FFmpeg.new(@filepath).read_tags
    end

    # Public: update_tags(updates)
    # Updates existing tags, adds a tag if it does not exist.
    #
    # updates - This takes a hash of keys matching a tag name with a value.
    #
    # Examples
    #
    #   audio_file.update_tags({artist: 'New Artist', album: 'New Album'})
    #
    def update_tags(updates)
      FFmpeg.new(@filepath).update_tags(updates)
    end
  end
end
