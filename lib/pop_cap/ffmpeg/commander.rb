require 'open3'

module PopCap
  # Public: This is a wrapper for the Open3 Ruby Standard Library.
  #
  # Examples
  #
  #   options = %W{ls} + %W{-lh}
  #   Commander.new(options).execute.output
  #   # => <directory contents>
  #
  class Commander
    # Public: Initialize
    #
    # args - Arguments should be escaped with an interpolated literal.
    #
    def initialize(*args)
      raise(ArgumentError, error_message) if args.empty?
      @command = shell_escaped(*args)
      @executed = []
    end

    # Public: Execute the command using Open3.capture3.
    # It will return an instance of Commander, in order
    # to chain methods.
    #
    def execute
      @executed = Open3.capture3(*@command)
      self
    end

    # Public: Open3.capture3 returns an array of three elements.
    # The first element returned is stdout.
    #
    def stdout
      @executed[0]
    end

    # Public: Open3.capture3 returns an array of three elements.
    # The second element returned is stderr.
    #
    def stderr
      @executed[1]
    end

    # Public: Open3.capture3 returns an array of three elements.
    # The third element returned is status.  Status can have a
    # 'success?' of true or false.
    #
    # Examples
    #
    #   self.success?
    #   # => true
    #
    def success?
      @executed[2].success?
    end

    private
    def shell_escaped(*args)
      args.inject(%W{}) { |command, arg| command << arg }
    end

    def error_message
      'Cannot run command with no args.'
    end
  end
end
