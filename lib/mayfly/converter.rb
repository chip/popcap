module Mayfly
  # Internal: This module builds a command to convert an audio file
  # to the specified output format. The module is included in FFmpeg.
  #
  module Converter
    ::BitRateConversionError = Class.new(StandardError)
    ::FormatConversionError = Class.new(StandardError)

    ::VALIDBITRATES = %q(64 128 160 192 256 320)
    ::VALIDFORMATS = %q(aac flac m4a mp3 ogg wav)

    # Internal: This method takes an input format & optional bitrate
    # in order to supply the ffmpeg command used to convert.
    #
    # format - Provide a valid format as a string or symbol.
    # bitrate - Provide a valid bitrate as a string or integer.
    #
    def convert(format, bitrate=192)
      @bitrate = bitrate
      @format = format.downcase.to_s
      input_path + strict_mode + bitrate_options + output_path
    end

    private
    def bitrate_error_message
      'An invalid bitrate was supplied.  Try 64, 128, 160, 192, 256, 320.'
    end

    def bitrate_options
      return %W{} unless use_bitrate?
      %W{-ab #{@bitrate}k}
    end

    def format_error_message
      'An invalid format was supplied.  Try aac, flac, m4a, mp3, ogg, wav.'
    end

    def input_path
      %W{ffmpeg -i #{self.filepath}}
    end

    def output_filename
      self.filepath.sub(%r([^.]+\z),@format)
    end

    def output_path
      %W{#{output_filename}}
    end

    def strict_mode
      return %W{} unless use_strict_mode?
      %W{-strict -2}
    end

    def use_bitrate?
      unless VALIDBITRATES.include?(@bitrate.to_s)
        raise(BitRateConversionError, bitrate_error_message)
      end
      @format == 'mp3'
    end

    def use_strict_mode?
      unless VALIDFORMATS.include?(@format)
        raise(FormatConversionError, format_error_message)
      end
      @format == 'm4a'
    end
  end
end
