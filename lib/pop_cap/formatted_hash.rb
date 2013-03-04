require 'pop_cap/class_support'
require 'pop_cap/formatter'

module PopCap
  # Public: This class will apply all Formatters to
  # the supplied hash.
  #
  # new - Supply an unformatted hash.
  #
  class FormattedHash
    def initialize(unformatted)
      @unformatted = unformatted
    end

    # Public: This class will apply all Formatters to
    # the supplied hash.
    #
    def formatted
      @unformatted.merge(formatted_hash)
    end

    # Public: This wraps #new & #formatted.
    #
    def self.formatted(unformatted)
      new(unformatted).formatted
    end

    private
    def formatted_hash(formatters: Formatters::Formatter, support: ClassSupport)
      formatters.subclasses.inject({}) do |formatted, formatter|
        attribute = support.new(formatter).symbolize
        formatted.merge(formatted_attribute(formatter, attribute))
      end.reject { |_,val| val.nil? }
    end

    def formatted_attribute(formatter, attribute)
      {attribute => formatter.format(@unformatted[attribute])}
    end
  end
end
