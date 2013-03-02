require 'pop_cap/class_support'
require 'pop_cap/formatter'
require 'pop_cap/tag/formatted_tag'
require 'pop_cap/tag/unformatted_tag'
require 'pop_cap/tag/tag_struct'

module PopCap
  # Internal: This module is included in anything with a #raw_tags
  # attribute.  It is used to parse and build tags from FFmpeg raw output.
  #
  module Taggable
    # Internal: This method reloads memoized tags.
    def reload!
      @attributes, @tags, @hash = nil, nil, nil
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
      @hash ||= unformatted.merge(formatted)
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
      @tags ||= build_tag_struct(to_hash)
    end

    private
    def lines
      self.raw_tags.split("\n")
    end

    def build_tag_struct(hash)
      TagStruct.new(hash)
    end

    def unformatted
      @attributes ||=
        lines.inject({}) { |hsh,line| hsh.merge(UnformattedTag.new(line)).to_hash }
    end

    def formatted
      Formatters::Formatter.subclasses.inject({}) do |formatted, formatter|
        attribute = ClassSupport.new(formatter).symbolize
        formatted.merge({attribute => format(formatter, attribute)})
      end
    end

    def format(formatter, attribute, formatted_tag: FormattedTag)
      formatted_tag.format(formatter, unformatted[attribute])
    end
  end
end
