module PopCap
  # Public: This class adds methods to construct a class.
  #
  # name - This is the name of the class.
  #
  # Examples
  #   ClassSupport.new('array')
  #   ClassSupport.new('active_support')
  #   ClassSupport.new('active_record/base')
  #
  class ClassSupport
    attr_reader :name

    def initialize(name)
      @name = name.to_s
    end

    # Public: This method camel cases a string or symbol.
    #
    # Examples
    #   support = ClassSupport.new('active_support')
    #   support.camelize
    #   # => 'ActiveSupport'
    #
    def camelize
      name.split('_').map { |word| word.capitalize }.join
    end

    # Public: This namespaces a string by converting a filepath
    # to a namespaced constant.
    #
    # Examples
    #   support = ClassSupport.new('active_record/base')
    #   support.namespace
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
    #   support = ClassSupport.new('active_record/base')
    #   support.constantize
    #   # => ActiveSupport::Base
    #
    def constantize
      Object.module_eval(namespace)
    end

    # Public: This converts a string into a symbol.
    # It will handle CamelCased strings.
    #
    # option - It takes an option to demodulize the string.
    #
    # Examples
    #   support = ClassSupport.new('ActiveSupport')
    #   support.symbolize
    #   # => :active_support
    #
    #   support = ClassSupport.new('ActiveSupport::CamelCase')
    #   support.symbolize(:demodulize)
    #   # => :camel_case
    #
    def symbolize
      name.split('::').last.split(%r((?=[A-Z]))).join('_').downcase.to_sym
    end
  end
end
