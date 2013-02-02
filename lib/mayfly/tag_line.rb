require 'mayfly/tag_key'

module Mayfly
  # Internal: This class sanitizes the raw output of FFmpeg to
  # and builds a hash.
  #
  # line - This is a single line of raw output from FFmpeg.
  #
  class TagLine
    def initialize(line)
      @line = line
    end

    # Internal: This method builds a hash by splitting on the
    # first equal sign in a single line of content from FFmpeg.
    # It uses TagKey to create the key for the hash.
    #
    def to_hash
      return {} unless ( @line && is_a_tag? )
      key,val = @line.split('=',2)
      {TagKey.new(key).format => val}
    end

    private
    def is_a_tag?
      @line.match('=')
    end
  end
end
