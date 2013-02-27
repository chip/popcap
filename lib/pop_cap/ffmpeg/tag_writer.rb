require 'pop_cap/commander'
require 'fileutils'

module PopCap
  FFmpegError = Class.new(StandardError)

  # Public: This class wraps FFmpeg to write tags for a specified file.
  #
  class TagWriter
    attr_reader :file, :tags

    # Public: Construct the class by providing it a file and set of tags.
    #
    # file - A path to a file on the filesystem.
    # tags - A hash of tag attributes.
    #
    def initialize(file, tags, commander=Commander)
      @file, @tags = file, tags
      @commander = commander
    end

    # Public: This methods writes the tags to a temporary file, if
    # successful, it moves the temporary file over the original.  This
    # is done to prevent corrupting the original file.
    #
    def write
      success = commander.new(*write_command).execute.success?
      raise(FFmpegError, write_error_message) unless success
      FileUtils.move(tmppath, file)
    end

    # Public: A convenience class method to wrap #new & #write.
    #
    def self.write(file, tags, commander=Commander)
      new(file, tags, commander).write
    end

    private
    attr_reader :commander

    def tmppath
      '/tmp/' + File.basename(file)
    end

    def write_command
      %W{ffmpeg -i #{file}} + write_options + %W{#{tmppath}}
    end

    def write_options
      tags.inject(%W{}) do |options,tag|
        options << '-metadata' << tag.join('=')
      end
    end

    def write_error_message
      "Error updating #{file}"
    end
  end
end
