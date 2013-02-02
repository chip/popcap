module Mayfly
  # Internal: This class sanitizes the raw output of FFmpeg to
  # be used as a hash key.
  #
  # key - This is a single key as created by TagLine.
  #
  class TagKey
    def initialize(key)
      @key = key
    end

    # Internal: This method removes unwanted strings, downcases,
    # & symbolizes a key.  Additionally, it renames keys named
    # 'size' to 'filesize' in order to avoid potential conflicts
    # with Ruby's build-in method of the same name.
    #
    # Examples
    #   tk = TagKey.new('size')
    #   tk.format
    #   # => :filesize
    #
    def format
      return '' if ( @key.nil? || @key.empty? )

      @key.
        sub(/^TAG:/,'').
        sub(/^size\b/,'filesize').
        downcase.
        to_sym
    end
  end
end
