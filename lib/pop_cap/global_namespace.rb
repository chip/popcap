module PopCap
  # Public: This class helps return information about which
  # classes & modules are loaded in the ObjectSpace.
  #
  class GlobalNamespace
    attr_reader :const

    # Public: This method takes an optional class or module name.
    #
    # new - A class name or module name.
    #
    def initialize(const=nil)
      @const = const
    end

    # Public: This method returns true if #const is found in the ObjectSpace.
    #
    def in_namespace?
      self.class.all_names.include?(const)
    end

    # Public: This method returns all classes & modules in the ObjectSpace.
    #
    def self.all
      (classes + modules).uniq
    end

    # Public: This method returns all class & module names in the ObjectSpace.
    #
    def self.all_names
      (class_names + module_names).uniq
    end

    # Public: This method returns all class names in the ObjectSpace.
    #
    def self.class_names
      names(classes)
    end

    # Public: This method returns all classes in the ObjectSpace.
    #
    def self.classes
      find_objects_of_type(Class)
    end

    # Public: This method returns the difference between two states
    # of the ObjectSpace.
    #
    # options - A :before & :after state are required.
    #
    def self.difference(options={})
      options[:after] - options[:before]
    end

    # Public: This method returns all module names in the ObjectSpace.
    #
    def self.module_names
      names(modules)
    end

    # Public: This method returns all modules in the ObjectSpace.
    #
    def self.modules
      find_objects_of_type(Module)
    end

    private
    def self.names(objects)
      objects.map { |obj| obj.name }
    end

    def self.find_objects_of_type(type)
      ObjectSpace.each_object(type).map { |cls| cls }
    end
  end
end
