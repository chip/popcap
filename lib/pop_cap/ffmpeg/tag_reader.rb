require 'pop_cap/commander'

module PopCap
  FFmpegError = Class.new(StandardError)

  # Public: This class wraps FFprobe to read tags from a specified file.
  #
  class TagReader
    attr_reader :file

    # Public: Construct the class by providing it with a file.
    #
    # file - A path to a file on the filesystem.
    #
    def initialize(file, commander=Commander)
      @file = file
      @commander = commander
    end

    # Public: This method returns the results of FFprobe -show_format.
    #
    def read
      encode(read_output)
    end

    # Public: A convenience class method which wraps the instance
    # constructor.
    #
    def self.read(file, commander=Commander)
      new(file, commander).read
    end

    private

    def read_command
      %W{ffprobe -show_format} + %W{#{file}}
    end

    def read_output
      executed = @commander.new(*read_command).execute
      raise(FFmpegError, read_error_message) unless executed.success?
      executed.stdout
    end

    def encode(string)
      return string if string.valid_encoding?
      remove_invalid_bytes(string)
    end

    def remove_invalid_bytes(string)
      @string = string
      original_encoding = @string.encoding.name
      @string.encode!('UTF-16', original_encoding, undef:
                      :replace, invalid: :replace)
      @string.encode!('UTF-8')
    end

    def read_error_message
      "Error reading #{file}"
    end
  end
end
