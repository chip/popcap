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

    def included_formatters
      Dir["#{File.dirname(__FILE__)}/formatters/*.rb"].inject({}) do |hash,path|
        @path = path
        file_name, required = required_files
        hash[file_name.to_sym] = required; hash
      end
    end

    private
    def required_files
      file_name = File.basename(@path , '.rb')
      required = 'pop_cap/formatters/' + file_name
      require required
      [file_name, required]
    end
  end
end
