module PopCap
  # Public: This is a super class for all formatter classes.
  # It establishes the default behavior of formatter classes.
  #
  class TagFormatter
    attr_reader :value, :options

    # Public: This class is constructed with a value & options hash.
    #
    # value - The value to be formatted.
    # options - An options hash.
    #
    def initialize(value, options={})
      @value, @options = value, options
    end

    # Public: This method contains the handles the formating.
    #
    def format
    end

    # Public: A class method for convenience calling of #format.
    #
    def self.format(value, options={})
      new(value, options).format
    end
  end
end
