module PopCap
  # Internal: This module requires all formatters in "formatters/."
  #
  module Formatters
    # Internal: This constant is a hash of all files in "formatters/."
    # To add new custom formatters to Taggable#tags, add the formatter
    # to "formatters/."
    #
    # Formatters should follow this format:
    #
    # Examples
    #   attribute - :custom_formatter
    #   path - lib/pop_cap/formatters/custom_formatter.rb
    #   class - CustomFormatter
    #   format instance method - #format
    #
    #   # lib/pop_cap/formatters/custom_formatter.rb
    #   class CustomFormatter
    #     def format
    #       # code that formats
    #     end
    #   end
    #
    ::INCLUDED_FORMATTERS = {}

    Dir["#{File.dirname(__FILE__)}/formatters/*.rb"].each do |path|
      file_name = File.basename(path , '.rb')
      required = 'pop_cap/formatters/' + file_name
      require required
      ::INCLUDED_FORMATTERS[file_name.to_sym] = required
    end
  end
end
