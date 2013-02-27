module PopCap
  # Public: This class adds methods to construct a class.
  #
  # name - This is the name of the class.
  #
  # Examples
  #   ClassMaker.new('array')
  #   ClassMaker.new('active_support')
  #   ClassMaker.new('active_record/base')
  #
  class ClassMaker
    def initialize(name)
      @name = name.to_s
    end

    # Public: This method camel cases a string or symbol.
    #
    # Examples
    #   maker = ClassMaker.new('active_support')
    #   maker.camelize
    #   # => 'ActiveSupport'
    #
    def camelize
      @name.split('_').map { |word| word.capitalize }.join
    end

    # Public: This namespaces a string by converting a filepath
    # to a namespaced constant.
    #
    # Examples
    #   maker = ClassMaker.new('active_record/base')
    #   maker.namespace
    #   # => 'ActiveRecord::Base'
    #
    def namespace
      camelize.split('/').map do |word|
        _,head,tail = word.partition(%r(^[a-zA-Z]))
        head.upcase + tail
      end.join('::')
    end

    # Public: This converts a string into a constant.
    #
    # Examples
    #   maker = ClassMaker.new('active_record/base')
    #   maker.constantize
    #   # => ActiveSupport::Base
    #
    def constantize
      Object.module_eval(namespace)
    end
  end
end
