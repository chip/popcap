require 'mayfly/ffmpeg'

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

    # Public: Initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    #
    def initialize(filepath)
      @filepath = filepath
    end

    # Public: raw_tags
    # Returns the raw output of FFProbe's show_format option.
    #
    def raw_tags
      FFmpeg.new(@filepath).read_tags
    end
  end
end
