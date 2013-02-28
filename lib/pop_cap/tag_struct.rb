module PopCap
  # Public: This class is a simple implementation of a Ruby struct
  # like object.  It has a custom #to_s method & creates getter methods.
  #
  # new - This method takes a hash.  It raises an error if anything else
  # is provided.
  #
  # Examples
  #   ts = TagStruct.new({artist: 'Artist', date: 1984})
  #   ts.artist => 'Artist'
  #   ts.date => 1984
  #
  class TagStruct
    include Enumerable

    def initialize(hash)
      raise(ArgumentError, argument_error_message) unless hash.kind_of?(Hash)
      @hash = hash
      define_instance_methods
    end

    # Public: This method shows the class name & hash values as a string.
    #
    # Examples
    #   ts = TagStruct.new({artist: 'Artist', date: 1984})
    #   puts ts
    #   #=> '#<PopCap::TagStruct artist: Artist, date: 1984>'
    #
    def to_s
      methods = @hash.map { |key,val| %(#{key}: #{val}) }.join(', ')
      "#<#{self.class.name} " + methods + '>'
    end

    private
    def argument_error_message
      'Initialize with a hash.'
    end

    def define_instance_methods
      @hash.each do |key, val|
        unless self.class.respond_to? key
          define_singleton_method(key) { val }
        end
      end
    end
  end
end
