require 'pop_cap/class_maker'
require 'pop_cap/auto_loader'
require 'pop_cap/tag_line'
require 'pop_cap/tag_struct'

module PopCap
  # Internal: This module is included in anything with a #raw_tags
  # attribute.  It is used to parse and build tags from FFmpeg raw output.
  #
  module Taggable
    # Internal: This method reloads memoized tags.
    def reload!
      @lined, @tags, @hash = nil, nil, nil
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
      @hash ||= lined_hash.merge(formatted_attributes)
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

    def lined_hash
      @lined ||=
        lines.inject({}) { |hsh,line| hsh.merge(TagLine.new(line)).to_hash }
    end

    # formatters.inject({}) do |formatted, formatter| 
    #   klass_for(formatter).format(attribute_for(formatter)
    #   formatted.merge(formatted_attribute)
    # end
    
    def formatted_attributes
      formatter_filepaths.inject({}) do |formatted, filepath|
        name, path = filepath
        klass = ClassMaker.new(cleaned_path(path)).constantize
        formatted.merge({name => formatter_class(name,klass)})
      end
    end

    def formatter_class(key, klass)
      klass.format(lined_hash[key])
    end

    def cleaned_path(klass)
      klass.sub(%r(^lib\/),'')
    end

    def formatter_filepaths(autoloader=AutoLoader)
      autoloader.require_all('lib/pop_cap/formatters').loaded_paths
    end
  end
end
