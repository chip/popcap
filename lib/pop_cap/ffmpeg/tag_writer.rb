require 'pop_cap/commander'
require 'fileutils'

module PopCap
  FFmpegError = Class.new(StandardError)

  class TagWriter
    attr_reader :file, :tags

    def initialize(file, tags, commander=Commander)
      @file, @tags = file, tags
      @commander = commander
    end

    def write
      success = commander.new(*write_command).execute.success?
      raise(FFmpegError, write_error_message) unless success
      FileUtils.move(tmppath, file)
    end

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
