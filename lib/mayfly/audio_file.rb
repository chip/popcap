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
    include Taggable

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
