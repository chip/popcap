require 'pop_cap/tag/tag_key'

module PopCap
  # Public: This class sanitizes the raw output of FFmpeg to
  # and builds a hash.
  #
  # line - This is a single line of raw output from FFmpeg.
  #
  class UnformattedTag
    def initialize(line)
      @line = line
    end

    # Public: This method builds a hash by splitting on the
    # first equal sign in a single line of content from FFmpeg.
    # It uses TagKey to create the key for the hash.
    #
    # Examples
    #   tag = UnformattedTag.new('TAG:ARTIST=David Bowie')
    #   tag.to_hash
    #   # => {artist: 'David Bowie'}
    #
    def to_hash
      return {} unless ( @line && is_a_tag? )
      key,val = @line.split('=',2)
      {TagKey.format(key) => val}
    end

    # Public: This method conveniently wraps #new & #to_hash.
    #
    def self.to_hash(line)
      new(line).to_hash
    end

    private
    def is_a_tag?
      @line.match('=')
    end
  end
end
