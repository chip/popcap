module Mayfly
  module Formatters
    # Internal: This class formats a filesize as human readable,
    # following a UNIX formatting standard.
    #
    # filesize - Provide a filesize as string, integer, or float.
    #
    class Filesize
      BASE = 1024
      UNITS = %W{B K M G T}

      def initialize(filesize)
        @filesize = filesize
      end

      # Internal: This method will format the filesize.
      # It raises a warning message if size is greater than 999 terabytes.
      #
      # Examples
      #   fs = Filesize.new(12345678)
      #   fs.format
      #   # => '11.8M'
      #
      def format
        return if @filesize.to_i == 0
        return warning_message if too_large?
        converted_filesize.to_s + measurement_character
      end

      private
      def binary_filesize
        float / BASE ** exponent
      end

      def converted_filesize
        rounded = rounded_filesize
        is_zero_decimal? ? rounded.ceil : rounded
      end

      def exponent
        (Math.log(float)/Math.log(BASE)).to_i
      end

      def float
        Float(@filesize)
      end

      def is_zero_decimal?
        rounded_filesize.denominator == 1
      end

      def measurement_character
        UNITS[exponent]
      end

      def rounded_filesize
        binary_filesize.round(1)
      end

      def too_large?
        @filesize.to_i > 1099400000000000
      end

      def warning_message
        'Warning: Number is larger than 999 terabytes.'
      end
    end
  end
end
