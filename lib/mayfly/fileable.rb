require 'fileutils'

module Mayfly
  PathError = Class.new(StandardError)

  # Public: This is a wrapper for the File & FileUtils Ruby 
  # Standard Libraries.  The module requires it be included in 
  # a class which has a #filepath method that returns a filepath.
  #
  module Fileable

    # Public: This will backup a file to a specified directory.
    #
    # backup_dir - path to a directory on the filesystem.
    # It defaults to '/tmp'.
    #
    # Examples
    #   audio_file.backup('/usr')
    #   # => file is copied to '/usr'
    #
    def backup(backup_dir='/tmp')
      @backup_dir = backup_dir
      FileUtils.cp(self.filepath, backup_path)
    end

    # Public: This will return the backup path.
    # It will raise an error if file was not backed up previously.
    #
    # Examples
    #   klass = SomeClass.new('path/to/file.txt').backup('/tmp')
    #   klass.backup_path
    #   # => '/tmp/file.txt'
    #
    def backup_path
      raise(PathError, backup_path_error_message) unless @backup_dir
      "#{@backup_dir}/" + filename
    end

    # Public: This will return the filename, excluding directory.
    #
    # Examples
    #   SomeClass.new('path/to/file.txt').filename
    #   # => 'file.txt'
    #
    def filename
      File.basename(self.filepath)
    end

    # Public: This will restore a file from the backup path.
    # It will raise an error if file has no backup path.
    #
    # from_path - The path from which to restore.  It defaults 
    # to the #backup_path.
    #
    # Examples
    #   klass = SomeClass.new('path/to/file.txt').backup('/tmp')
    #   klass.restore
    #
    def restore(from_path=nil)
      @from_path = from_path
      FileUtils.mv(restore_path, self.filepath)
    end

    # Public: This returns a temporary path for the file.
    #
    # Examples
    #   klass = SomeClass.new('path/to/file.txt').tmppath
    #   # => '/tmp/file.txt'
    #
    def tmppath
      '/tmp/' + filename
    end

    private
    def backup_path_error_message
      'Cannot determine backup path.'
    end

    def restore_path
      return backup_path unless @from_path
      @from_path + '/' + filename
    end
  end
end
