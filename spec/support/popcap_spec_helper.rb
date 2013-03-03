require 'fileutils'
require 'ostruct'
require 'json'

module PopCapSpecHelper
  SAMPLE_FILE = 'spec/fixtures/sample.flac'

  class << self
    def raw_tags
      '{"format":{"filename":"/home/marsalis/.apps/popcap/spec/fixtures/'\
        'sample.flac","nb_streams":1,"format_name":"flac","format_long_name"'\
        ':"raw FLAC","duration":"1.000000","size":"18291","bit_rate":"146328"'\
        ',"tags":{"GENRE":"Sample Genre","track":"01","ALBUM":"Sample Album",'\
        '"DATE":"2012","TITLE":"Sample Title","ARTIST":"Sample Artist"}}}'
    end

    def unformatted_hash
      {
        filename: File.realpath(SAMPLE_FILE),
        nb_streams: 1,
        format_name: 'flac',
        format_long_name: 'raw FLAC',
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

    def formatted_hash
      {
        filename: File.realpath(SAMPLE_FILE),
        nb_streams: 1,
        format_name: 'flac',
        format_long_name: 'raw FLAC',
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
        filename: File.realpath(SAMPLE_FILE),
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
      FileUtils.rm_f('spec/fixtures/sample.mp3')
    end

    def setup
      FileUtils.cp(SAMPLE_FILE, 'spec/fixtures/backup.flac')
    end

    def teardown
      FileUtils.mv('spec/fixtures/backup.flac', SAMPLE_FILE)
      FileUtils.rm_f('spec/fixtures/sample.mp3')
    end

    def object_names(const)
      ObjectSpace.each_object(const).map { |cls| cls.name }
    end

    def all_names
      ObjectSpace.each_object(Object).map do |obj|
        obj.name if(obj.is_a?(Class) || obj.is_a?(Module))
      end.compact
    end

    def classes
      ObjectSpace.each_object(Class).map { |cls| cls }
    end

    def modules
      ObjectSpace.each_object(Module).map { |cls| cls }
    end
  end
end
