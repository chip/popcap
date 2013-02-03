require 'fileutils'
require 'ostruct'

module MayflySpecHelper
  class << self
    def raw_tags
      <<-EOF.gsub(/^\s+/,'')
        [FORMAT]
        filename=spec/support/sample.flac
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
        filename: 'spec/support/sample.flac',
        nb_streams: '1',
        format_name: 'flac',
        format_long_name: 'raw FLAC',
        start_time: 'N/A',
        duration: '1.000000',
        filesize: '18291',
        bit_rate: '146328',
        genre: 'Sample Genre',
        track: '01',
        album: 'Sample Album',
        date: '2012',
        title: 'Sample Title',
        artist: 'Sample Artist'
      }
    end

    def tags
      OpenStruct.new(
        {
        filename: 'spec/support/sample.flac',
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

    def setup
      FileUtils.cp('spec/support/sample.flac', 'spec/support/backup.flac')
    end

    def teardown
      FileUtils.mv('spec/support/backup.flac', 'spec/support/sample.flac')
    end
  end
end
