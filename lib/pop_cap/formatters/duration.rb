require 'pop_cap/formatter'

module PopCap
  module Formatters
    # Public: This will format a duration tag as strftime.
    #
    # time - Provide a string, float, or integer.
    class Duration < Formatter
      # Public: This will format a duration tag as strftime.
      # It will raise a warning if the time is greater than 24 hours.
      # Leading zeroes & colons are removed.
      #
      # Examples
      #   dur = Duration.new(420)
      #   dur.format
      #   # => '7:00'
      #
      def format
        return unless value.to_i > 0
        return warning_message if over_twenty_four_hours?
        human_readable_time
      end

      private
      def human_readable_time
        to_strftime.sub(/^(0+|:)+/,'')
      end

      def to_strftime
        Time.at(value.to_f).gmtime.strftime('%H:%M:%S')
      end

      def over_twenty_four_hours?
        value.to_i > 86399
      end

      def warning_message
        'Warning: Time is greater than 24 hours.'
      end
    end
  end
end
