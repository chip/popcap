require 'pop_cap/commander'

module PopCap
  FFmpegError = Class.new(StandardError)

  # Public: This class converts an audio file to the specified
  # output format.
  #
  class Converter
    attr_reader :bitrate, :commander, :file, :format

    # Public: This method takes a filepath, output format &
    # optional bitrate.
    #
    # file - The path to the file to convert.
    # format - Provide a valid format as a string or symbol.
    # bitrate - Provide a valid bitrate as a string or integer.
    #
    def initialize(file, options={})
      @file = file
      @format = options[:format].downcase.to_s
      @bitrate = options[:bitrate] || 192
      @commander = options[:commander] || Commander
    end

    # Public: This method will execute the conversion.
    #
    def convert
      execute = commander.new(*conversion_command).execute
      raise(FFmpegError, conversion_error) unless execute.success?
    end

    # Public: A convenience class method which wraps the instance
    # constructor.
    #
    def self.convert(file, options={})
      new(file, options).convert
    end

    private
    def conversion_command
      input_path + strict_mode + bitrate_options + output_path
    end

    def conversion_error
      "Error converting #{file}."
    end

    def bitrate_options
      %W{-ab #{bitrate}k}
    end

    def input_path
      %W{ffmpeg -i #{file}}
    end

    def output_path
      %W{#{file.sub(%r([^.]+\z),format)}}
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
