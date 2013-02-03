module Mayfly
  # Public: This class adds helper methods to construct a class.
  #
  # name - This is the name of the class.
  #
  # Examples
  #   Helper.new('array')
  #   Helper.new('active_support')
  #   Helper.new('active_record/base')
  #
  class Helper
    def initialize(name)
      @name = name.to_s
    end

    # Public: This method camel cases a string or symbol.
    #
    # Examples
    #   helper = Helper.new('active_support')
    #   helper.camelize
    #   # => 'ActiveSupport'
    #
    def camelize
      @name.split('_').map { |word| word.capitalize }.join
    end

    # Public: This namespaces a string by converting a filepath
    # to a namespaced constant.
    #
    # Examples
    #   helper = Helper.new('active_record/base')
    #   helper.namespace
    #   # => 'ActiveRecord::Base'
    #
    def namespace
      camelize.split('/').map do |word| 
        _,head,tail = word.partition(%r(^[a-z]|[A-Z]))
        head.upcase + tail
      end.join('::')
    end

    # Public: This converts a string into a constant.
    #
    # Examples
    #   helper = Helper.new('active_record/base')
    #   helper.constantize
    #   # => ActiveSupport::Base
    #
    def constantize
      Object.module_eval(namespace)
    end
  end
end
