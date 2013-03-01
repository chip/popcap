module PopCap
  # Public: This class will autoload all Ruby files in a given directory.
  #
  class AutoLoader
    attr_reader :directory

    # Public: To construct a new instance of AutoLoader, provide a
    # directory path.
    #
    # directory - A path to a directory.
    #
    def initialize(directory)
      @directory = File.join(directory, '')
    end

    # Public: This will return the autoloaded files & their paths
    # as a hash with the key being the filename & the value the
    # path to the file.
    #
    def loaded_paths
      ruby_files.inject({}) do |pathnames, file|
        pathnames[path_keyname(file)] = shortpath(file)
        pathnames
      end
    end

    # Public: This will require all Ruby files in the provided
    # directory.
    #
    def require_all
      ruby_files.each { |file| require file }
      self
    end

    # Public: A class method which wraps the behavior of require_all.
    #
    # directory - A directory path.
    #
    def self.require_all(directory)
      new(directory).require_all
    end

    private
    def basename(file)
      File.basename(file, '.rb')
    end

    def path_keyname(file)
      basename(file).to_sym
    end

    def ruby_files
      @files ||= Dir[File.realpath(directory) + '/*.rb']
    end

    def shortpath(file)
      directory + basename(file)
    end
  end
end
