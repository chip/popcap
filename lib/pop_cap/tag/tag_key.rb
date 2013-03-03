module PopCap
  # Public: This class sanitizes the raw output of FFmpeg to
  # be used as a hash key.
  #
  # key - This is a single key as created by TagLine.
  #
  class TagKey
    attr_reader :key

    def initialize(key)
      @key = key
    end

    # Public: This method removes unwanted strings, downcases,
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
      return '' unless is_valid?
      @key.
        sub(/^TAG:/,'').
        sub(/^size\b/,'filesize').
        downcase.
        to_sym
    end

    # Public: This method wraps #new & #format.
    # 
    def self.format(key)
      new(key).format
    end

    private
    def is_valid?
      !(key.to_s.empty?)
    end
  end
end
