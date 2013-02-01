require 'fileutils'

module Mayfly
  PathError = Class.new(StandardError)
  RestoreError = Class.new(StandardError)

  # Public: This is a wrapper for the File & FileUtils Ruby 
  # Standard Libraries.  The module requires it be included in 
  # a class which has a #filepath method that returns a filepath.
  #
  module Fileable

    # Public: This will backup a file to a specified directory.
    #
    # backup_dir - path to a directory on the filesystem.
    #
    # Examples
    #   audio_file.backup('/tmp')
    #   # => file is copied to '/tmp'
    #
    def backup(backup_dir)
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
    # Examples
    #   klass = SomeClass.new('path/to/file.txt').backup('/tmp')
    #   klass.restore
    #
    def restore
      raise(RestoreError, file_restore_error_message) unless @backup_dir
      FileUtils.mv(backup_path, self.filepath)
    end

    private
    def file_restore_error_message
      'Cannot restore a file which has not been backed up.'
    end

    def backup_path_error_message
      'Cannot show backup path if file has not been backed up.'
    end
  end
end
