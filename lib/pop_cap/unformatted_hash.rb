require 'json'

module PopCap
  # Public: This class formats the JSON output of TagReader.
  #
  class UnformattedHash
    attr_reader :json

    def initialize(json)
      @json = json
    end

    # Public: This method returns a Ruby hash.
    # The keys have been converted to symbols.
    #
    def hash
      renamed_hash
    end

    # Public: This method wraps #new & #hash.
    #
    def self.hash(json)
      new(json).hash
    end

    private
    def renamed_hash
      symbolized_hash.
        merge({filesize: size_element}).
        reject { |key,_| key == :size }
    end

    def symbolized_hash
      Hash[merged_hashes.map { |key,val| [key.downcase.to_sym, val] }]
    end

    def merged_hashes
      format_hash.merge(tags_hash)
    end

    def size_element
      format_hash['size']
    end

    def format_hash
      @format ||= parsed_json.reject { |key,_| key == 'tags' }
    end

    def tags_hash
      parsed_json['tags'] || parsed_json
    end

    def parsed_json
      @parsed ||= JSON.parse(json)['format']
    end
  end
end
