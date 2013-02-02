module Mayfly
  module Formatters
    # Internal: This is a formatter for the bit_rate tag.  It is used
    # to make the bitrate human readable.
    #
    # bitrate - The bitrate can be sent as a string or integer.
    #
    class BitRate
      def initialize(bitrate)
        @bitrate = bitrate
      end

      # Internal: This method returns a bitrate represented in kilobytes.
      #
      # It returns nil for anything that is not a number greater than
      # zero.
      #
      # Examples
      #   br = BitRate.new(128456)
      #   br.format_bit_rate
      #   # => '128 kb/s'
      #
      def format_bit_rate
        return unless @bitrate.to_i > 0
        @bitrate.to_s[0..-4] + ' kb/s'
      end
    end
  end
end
