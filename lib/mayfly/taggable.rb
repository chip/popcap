require 'mayfly/helper'
require 'mayfly/tag_line'
require 'ostruct'

module Mayfly
  # Internal: This module is included in anything with a #raw_tags
  # attribute.  It is used to parse and build tags from FFmpeg raw output.
  #
  module Taggable
    ::FORMATTERS_PATH = 'mayfly/formatters/'
    ::FORMATTERS = {}

    Dir["lib/#{::FORMATTERS_PATH}*.rb"].each do |path|
      file_name = File.basename(path, '.rb')
      required = ::FORMATTERS_PATH + file_name
      require required
      ::FORMATTERS[file_name.to_sym] = required.sub(%r(^lib\/),'')
    end

    # Internal: This method builds a sanitized hash from #raw_tags.
    #
    # Examples
    #   class SomeClass
    #     def raw_tags
    #     end
    #   end
    #
    #   klass = SomeClass.new
    #   klass.to_hash
    #   # =>
    #       { filename: 'spec/support/sample.flac',
    #         format_name: 'flac',
    #         duration: '1.000000',
    #         filesize: '18291',
    #         bit_rate: '146328',
    #         genre: 'Sample Genre',
    #         track: '01',
    #         album: 'Sample Album',
    #         date: '2012',
    #         title: 'Sample Title',
    #         artist: 'Sample Artist' }
    #
    def to_hash
      @hash = 
        lines.inject({}) { |hash,line| hash.merge(TagLine.new(line)).to_hash }
    end

    # Public: This method builds an OpenStruct from #to_hash. Also,
    # TagFormatters are applied to any tag with a custom formatter.
    #
    # Examples
    #   class SomeClass
    #     def raw_tags
    #     end
    #   end
    #
    #   klass = SomeClass.new
    #   klass.tags
    #
    #   # =>
    #    .album             =>  'Sample Album'
    #    .artist            =>  'Sample Artist'
    #    .bit_rate          =>  '146 kb/s'
    #    .date              =>  2012
    #    .duration          =>  '1'
    #    .filename          =>  'spec/support/sample.flac'
    #    .filesize          =>  '17.9K'
    #    .format_long_name  =>  'raw FLAC'
    #    .format_name       =>  'flac'
    #    .genre             =>  'Sample Genre'
    #    .nb_streams        =>  '1'
    #    .start_time        =>  'N/A'
    #    .title             =>  'Sample Title'
    #    .track             =>  '01'
    #
    def tags
      OpenStruct.new(to_hash.merge(formatted_hash))
    end

    private
    def lines
      self.raw_tags.split("\n")
    end

    def formatted_hash
      ::FORMATTERS.inject({}) do |formatted, formatter|
        key, value = formatter
        helper = Helper.new(value)
        klass = helper.constantize
        formatted.merge({key => klass.new(@hash[key]).format})
      end
    end
  end
end
