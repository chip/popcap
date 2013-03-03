require 'pop_cap/class_support'
require 'pop_cap/formatter'
require 'pop_cap/tag/formatted_tag'
require 'pop_cap/tag/tag_hash'
require 'pop_cap/tag/tag_struct'

module PopCap
  # Public: This module is included in anything with a #raw_tags
  # attribute.  It is used to parse and build tags from FFmpeg raw output.
  #
  module Taggable
    # Public: This method reloads memoized tags.
    #
    def reload!
      @unformatted_hash, @formatted_hash, @tag_struct = nil, nil, nil
    end

    # Public: This method builds an unformatted hash of tags.
    #
    # Examples
    #   class SomeClass
    #     def raw_tags
    #     end
    #   end
    #
    #   klass = SomeClass.new
    #   klass.unformatted
    #   # =>
    #       { filename: 'spec/fixtures/sample.flac',
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
    def unformatted(tag_hash: TagHash)
      @unformatted_hash ||= tag_hash.hash(self.raw_tags)
    end

    # Public: This method builds an unformatted hash of tags.
    #
    # Examples
    #   class SomeClass
    #     def raw_tags
    #     end
    #   end
    #
    #   klass = SomeClass.new
    #   klass.unformatted
    #   # =>
    #       { filename: 'spec/fixtures/sample.flac',
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
    def formatted
      @formatted_hash ||= unformatted.merge(formatted_tags)
    end

    # Public: This method builds an tag structure from #to_hash. Also,
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
    def tags
      @tag_struct ||= build_tag_struct(formatted)
    end

    private
    def build_tag_struct(hash)
      TagStruct.new(hash)
    end

    def format(formatter, attribute, tag: FormattedTag)
      tag.format(formatter, unformatted[attribute])
    end

    def formatted_tags
      Formatters::Formatter.subclasses.inject({}) do |formatted, formatter|
        attribute = ClassSupport.new(formatter).symbolize
        formatted.merge({attribute => format(formatter, attribute)})
      end
    end
  end
end
