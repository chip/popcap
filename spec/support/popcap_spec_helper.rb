require 'fileutils'
require 'ostruct'

module PopCapSpecHelper
  class << self
    def raw_tags
      <<-EOF.gsub(/^\s+/,'')
        [FORMAT]
        filename=#{File.realpath('spec/support/sample.flac')}
        nb_streams=1
        format_name=flac
        format_long_name=raw FLAC
        start_time=N/A
        duration=1.000000
        size=18291
        bit_rate=146328
        TAG:GENRE=Sample Genre
        TAG:track=01
        TAG:ALBUM=Sample Album
        TAG:DATE=2012
        TAG:TITLE=Sample Title
        TAG:ARTIST=Sample Artist
        [/FORMAT]
      EOF
    end

    def to_hash
      {
        filename: File.realpath('spec/support/sample.flac'),
        nb_streams: '1',
        format_name: 'flac',
        format_long_name: 'raw FLAC',
        start_time: 'N/A',
        duration: '1',
        filesize: '17.9K',
        bit_rate: '146 kb/s',
        genre: 'Sample Genre',
        track: '01',
        album: 'Sample Album',
        date: 2012,
        title: 'Sample Title',
        artist: 'Sample Artist'
      }
    end

    def tags
      OpenStruct.new(
        {
        filename: File.realpath('spec/support/sample.flac'),
        nb_streams: '1',
        format_name: 'flac',
        format_long_name: 'raw FLAC',
        start_time: 'N/A',
        duration: '1',
        filesize: '17.9K',
        bit_rate: '146 kb/s',
        genre: 'Sample Genre',
        track: '01',
        album: 'Sample Album',
        date: 2012,
        title: 'Sample Title',
        artist: 'Sample Artist' })
    end

    def remove_converted
      FileUtils.rm_f('spec/support/sample.mp3')
    end

    def setup
      FileUtils.cp('spec/support/sample.flac', 'spec/support/backup.flac')
    end

    def teardown
      FileUtils.mv('spec/support/backup.flac', 'spec/support/sample.flac')
    end

    def benchmark(&block)
      start = Time.now
      raise(ArgumentError, 'Provide a block.') unless block_given?
      yield
      finish = Time.now
      puts "Time elapsed: #{((finish - stop)*1000).round(3)}ms"
    end
  end
end
