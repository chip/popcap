require 'pop_cap/ffmpeg/ffmpeg'
require 'fileutils'

module PopCap
  # Public: This class wraps FFmpeg to write tags for a specified file.
  #
  class TagWriter < FFmpeg
    # Public: This methods writes the tags to a temporary file, if
    # successful, it moves the temporary file over the original.  This
    # is done to prevent corrupting the original file.
    #
    def write
      unless execute.success?
        cleanup_failed_write
        raise(FFmpegError, error_message('writing'))
      end
      FileUtils.move(tmppath, filepath)
    end

    # Public: A convenience class method to wrap #new & #write.
    #
    def self.write(filepath, options = {})
      new(filepath, options).write
    end

    private
    def tmppath
      @tmp ||= '/tmp/' + File.basename(filepath)
    end

    def command
      %W{ffmpeg -i #{filepath}} + write_options + %W{#{tmppath}}
    end

    def write_options
      clean_tags.inject(%W{}) do |tags,tag|
        tags << '-metadata' << tag.join('=')
      end
    end

    def clean_tags
      @cleaned ||= options.reject { |key,_| key == :commander }
    end

    def cleanup_failed_write
      FileUtils.rm_f(tmppath)
    end
  end
end
