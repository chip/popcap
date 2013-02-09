module PopCap
  # Internal: This module builds a command to convert an audio file
  # to the specified output format. The module is included in FFmpeg.
  #
  module Converter
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
    def bitrate_options
      %W{-ab #{@bitrate}k}
    end

    def input_path
      %W{ffmpeg -i #{self.filepath}}
    end

    def output_path
      %W{#{self.filepath.sub(%r([^.]+\z),@format)}}
    end

    def strict_mode
      return %W{} unless use_strict_mode?
      %W{-strict -2}
    end

    def use_strict_mode?
      @format == 'm4a'
    end
  end
end
