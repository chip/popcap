require 'json'
require 'pop_cap/ffmpeg/ffmpeg'

module PopCap
  # Public: This class wraps FFprobe to read tags from a specified file.
  #
  class TagReader < FFmpeg
    # Public: This method returns the results of FFprobe -show_format.
    #
    def read
      JSON.load(encode(output)).to_json
    end

    # Public: A convenience class method which wraps the instance
    # constructor.
    #
    def self.read(filepath, options={})
      new(filepath, options).read
    end

    private
    def command
      %W{ffprobe -show_format -print_format json} + %W{#{filepath}}
    end

    def output
      executed = commander.new(*command).execute
      raise(FFmpegError, error_message('reading')) unless executed.success?
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
  end
end
