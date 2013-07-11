require 'pop_cap/ffmpeg/ffmpeg'

module PopCap
  # Public: This class converts an audio file to the specified
  # output format.
  #
  class Converter < FFmpeg
    # Public: This method will execute the conversion.
    #
    def convert
      unless execute.success?
        raise(FFmpegError, error_message('converting'))
      end
    end

    # Public: A convenience class method which wraps the instance
    # constructor.
    #
    def self.convert(filepath, options={})
      new(filepath, options).convert
    end

    private
    def format
      options[:format].downcase.to_s
    end

    def bitrate
      options[:bitrate] || 192
    end

    def command
      input_path + strict_mode + bitrate_options + output_path
    end

    def bitrate_options
      %W{-ab #{bitrate}k}
    end

    def input_path
      %W{ffmpeg -i #{filepath}}
    end

    def output_path
      %W{#{filepath.sub(%r([^.]+\z),format)}}
    end

    def strict_mode
      return %W{} unless use_strict_mode?
      %W{-strict -2}
    end

    def use_strict_mode?
      format == 'm4a'
    end
  end
end
