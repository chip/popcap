require 'pop_cap/ffmpeg/converter'
require 'pop_cap/ffmpeg/tag_reader'
require 'pop_cap/ffmpeg/tag_writer'
require 'pop_cap/unformatted_hash'
require 'pop_cap/formatted_hash'
require 'pop_cap/tag_struct'
require 'pop_cap/fileable'

module PopCap
  FileNotFound = Class.new(StandardError)
  # Public: This is a class for managing audio files on the filesystem.
  # It is used to read & write metadata tags, convert between audio formats,
  # and manage a file on the filesystem using standard UNIX file commands.
  #
  # Examples
  #
  #   filepath = 'spec/fixtures/sample.flac'
  #   af = AudioFile.new(filepath)
  #
  #
  class AudioFile
    include Fileable
    attr_accessor :filepath

    ::MEMOIZABLES = %w(@raw @unformatted_hash @formatted_hash @tag_struct)

    # Public: Initialize
    #
    # filepath - Requires a valid filepath to a file on the local filesystem.
    #
    def initialize(filepath)
      raise(FileNotFound, filepath) unless File.exists?(filepath)
      @filepath = File.realpath(filepath)
    end

    # Public: convert
    # This method converts an audio file between formats.
    # It takes an optional bitrate for mp3 formats.
    #
    # format - A valid audio file format as string or symbol.
    # bitrate - An optional bitrate for mp3s.
    #
    # Examples
    #   audio_file = AudioFile.new('spec/fixtures/sample.flac')
    #   audio_file.convert('mp3', 128)
    #   # => 'spec/fixtures/sample.mp3'
    #
    def convert(format, bitrate=192, converter: Converter)
      converter.convert(filepath, {format: format, bitrate: bitrate})
    end

    # Public: raw_tags
    # This method returns the raw_tags from FFmpeg.
    #
    # Examples
    #   audio_file = AudioFile.new('spec/fixtures/sample.flac')
    #   audio_file.raw_tags
    #   # =>
    #
    #  {
    #    "format":
    #      {
    #        "filename":"spec/fixtures/sample.flac",
    #        "nb_streams":1,
    #        "format_name":"flac",
    #        "format_long_name":"raw FLAC",
    #        "duration":"1.000000",
    #        "size":"18291",
    #        "bit_rate":"146328",
    #          "tags":
    #          {
    #            "GENRE":"Sample Genre",
    #            "track":"01",
    #            "ALBUM":"Sample Album",
    #            "DATE":"2012",
    #            "TITLE":"Sample Title",
    #            "ARTIST":"Sample Artist"
    #          }
    #      }
    #  }
    #
    def raw_output(tag_reader: TagReader)
      @raw ||= tag_reader.read(filepath)
    end

    # Public: This method returns a sanitized version of #raw_tags.
    #
    #  {
    #    filename: '$HOME/spec/fixtures/sample.flac',
    #    nb_streams: 1,
    #    format_name: 'flac',
    #    format_long_name: 'raw FLAC',
    #    duration: '1.000000',
    #    filesize: '18291',
    #    bit_rate: '146328',
    #    genre: 'Sample Genre',
    #    track: '01',
    #    album: 'Sample Album',
    #    date: '2012',
    #    title: 'Sample Title',
    #    artist: 'Sample Artist'
    #  }
    #
    def unformatted(unformatted_hash: UnformattedHash)
      @unformatted_hash ||= unformatted_hash.hash(raw_output)
    end

    # Public: This method returns #unformatted tags with
    # any available Formatters automatically applied.
    #
    #  {
    #    filename: '$HOME/spec/fixtures/sample.flac',
    #    nb_streams: 1,
    #    format_name: 'flac',
    #    format_long_name: 'raw FLAC',
    #    duration: '1',
    #    filesize: '17.9K',
    #    bit_rate: '146 kb/s',
    #    genre: 'Sample Genre',
    #    track: '01',
    #    album: 'Sample Album',
    #    date: 2012,
    #    title: 'Sample Title',
    #    artist: 'Sample Artist'
    #  }
    def formatted(formatted_hash: FormattedHash)
      @formatted_hash ||= formatted_hash.formatted(unformatted)
    end

    # Public: This method builds a tag structure from #formatted.
    #
    #    .album             =>  'Sample Album'
    #    .artist            =>  'Sample Artist'
    #    .bit_rate          =>  '146 kb/s'
    #    .date              =>  2012
    #    .duration          =>  '1'
    #    .filename          =>  'spec/fixtures/sample.flac'
    #    .filesize          =>  '17.9K'
    #    .format_long_name  =>  'raw FLAC'
    #    .format_name       =>  'flac'
    #    .genre             =>  'Sample Genre'
    #    .nb_streams        =>  '1'
    #    .start_time        =>  'N/A'
    #    .title             =>  'Sample Title'
    #    .track             =>  '01'
    #
    def tags(tag_struct: TagStruct)
      @tag_struct ||= tag_struct.new(formatted)
    end

    # Public: This method reloads the current instance.
    #
    # Examples
    #   audio_file.reload!
    #
    def reload!
      ::MEMOIZABLES.each { |var| self.instance_variable_set(var, nil) }
    end

    # Public: update(updates)
    # Updates existing tags, adds a tag if it does not exist.
    #
    # updates - This takes a hash of tags.
    #
    # Examples
    #
    #   audio_file.update(artist: 'New Artist', album: 'New Album')
    #
    def update(updates={})
      TagWriter.write(filepath, updates)
      self.reload!
      self.tags
    end
  end
end
