module PopCap
  # Public: This class will apply a provided Formatter to
  # the supplied value.
  #
  class FormattedTag
    attr_reader :formatter, :value

    # Public: To construct an instance, provide a Formatter
    # and the value to format.
    #
    # formatter - A class of type Formatters::Formatter.
    # value - The value to format.
    #
    def initialize(formatter, value)
      @formatter, @value = formatter, value
    end

    # Public: This returns the formatted value.
    #
    def format
      formatter.format(value)
    end

    # Public: A class level method that initializes the class
    # and formats the value.
    #
    def self.format(formatter, value)
      new(formatter, value).format
    end
  end
end
