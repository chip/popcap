require 'open3'

module Mayfly
  # Internal: This is a wrapper for the Open3 Ruby Standard Library.
  #
  # Examples
  #
  #   options = %W{ls} + %W{-lh}
  #   Commander.new(options).execute.output
  #   # => <directory contents>
  #
  class Commander
    # Internal: Initialize
    #
    # args - Arguments should be escaped with an interpolated literal.
    #
    def initialize(*args)
      raise(ArgumentError, error_message) if args.empty?
      @command = args.inject(%W{}) { |command, arg| command << arg }
      @executed = []
    end

    # Internal: Execute the command using Open3.capture3.
    # It will return an instance of Commander, in order
    # to chain methods.
    #
    def execute
      @executed = Open3.capture3(*@command)
      self
    end

    # Internal: Open3.capture3 returns an array of three elements.
    # The first element returned is stdout.
    #
    def stdout
      @executed[0]
    end

    # Internal: Open3.capture3 returns an array of three elements.
    # The second element returned is stderr.
    #
    def stderr
      @executed[1]
    end

    # Internal: Open3.capture3 returns an array of three elements.
    # The third element returned is status.  Status can have a 
    # 'success?' of true or false.
    #
    # Examples
    # 
    #   self.status.success?
    #   # => true
    #
    def status
      @executed[2]
    end

    private
    def error_message
      'Cannot run command with no args.'
    end
  end
end
