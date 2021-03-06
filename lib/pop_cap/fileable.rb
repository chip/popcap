require 'fileutils'

module PopCap
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

    # Public: This will remove the file from the system.
    #
    # Examples
    #   klass = SomeClass.new('path/to/file.txt')
    #   klass.destroy
    #
    def destroy
      FileUtils.rm_f(self.filepath)
      self.filepath = nil
    end

    # Public: This will return the directory, excluding the filename.
    #
    # Examples
    #   SomeClass.new('path/to/file.txt').directory
    #   # => 'path/to/'
    #
    def directory
      File.dirname(self.filepath)
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

    # Public: This method moves a file to destination.
    #
    # destination - The folder/directory to move the file.
    #
    # Examples
    #   klass = SomeClass.new('path/to/file.txt')
    #   klass.move('/tmp')
    #   # => '/tmp/file.txt'
    #
    def move(destination)
      FileUtils.mv(self.filepath, destination)
      self.filepath = destination + '/' + filename
    end

    # Public: This method renames a file.
    #
    # new_name - The new name of the file.
    #
    # Examples
    #   klass = SomeClass.new('path/to/file.txt')
    #   klass.rename('rename.txt')
    #   # => 'path/to/rename.txt'
    #
    def rename(new_name)
      new_path = self.directory + '/' + new_name
      FileUtils.mv(self.filepath, new_path)
      self.filepath = new_path
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
