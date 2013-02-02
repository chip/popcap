require 'mayfly/tag_line'

module Mayfly
  # Internal: This module is included in anything with a #raw_tags
  # attribute.  It is used to parse and build tags from FFmpeg raw output.
  #
  module Taggable

    # Internal: This method builds a sanitized hash from #raw_tags
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
      lines.inject({}) {|hash,line| hash.merge(TagLine.new(line)).to_hash }
    end

    private
    def lines
      self.raw_tags.split("\n")
    end
  end
end
