require 'pop_cap/formatter'

module PopCap
  module Formatters
    # Public: This is a formatter for the date tag.  It is used
    # to match and return the year.
    #
    # date - The date can be sent as a string or integer.
    # options - An optional hash for a start & end date range.
    #           The start_date defaults to 1800, end_date defaults
    #           to 2100.
    #
    class Date < Formatter
      # Public:  This method returns a year if it is matched.
      #
      # Examples
      #   date = Date.new('October 5, 1975')
      #   date.format
      #   # => '1975'
      #
      def format
        return unless ( date_match && within_date_range? )
        @match[0].to_i
      end

      def start_date
        options[:start_date] || 1800
      end

      def end_date
        options[:end_date] || 2100
      end

      private
      def date_match
        @match ||= value.to_s.match(/\b\d{4}\b/)
      end

      def within_date_range?
        (start_date..end_date).include?(@match[0].to_i)
      end
    end
  end
end
