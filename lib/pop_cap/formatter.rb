module PopCap
  module Formatters
    # Public: This is a super class for all formatter classes.
    # It establishes the default behavior of formatter classes.
    #
    class Formatter
      attr_reader :value, :options

      # Public: This class is constructed with a value & options hash.
      #
      # value - The value to be formatted.
      # options - An options hash.
      #
      def initialize(value, options={})
        @value, @options = value, options
      end

      # Public: This method contains the handles the formating.
      #
      def format
      end

      # Public: A class method for convenience calling of #format.
      #
      def self.format(value, options={})
        new(value, options).format
      end

      # Public: This returns an array of all subclasses.
      #
      def self.subclasses
        require_all_formatters

        ObjectSpace.each_object(Class).select do |klass|
          klass if is_a_subclass?(klass)
        end.uniq.compact
      end

      # Public: This returns an array of all subclasses "demodulized."
      #
      def self.subclasses_demodulized
        subclasses.map { |klass| demodulize(klass) }
      end

      private
      def self.require_all_formatters
        Dir["#{File.dirname(__FILE__)}/formatters/*.rb"].each do |file|
          require File.realpath(file)
        end
      end

      def self.demodulize(klass)
        klass.to_s.split('::').last
      end

      def self.is_a_subclass?(klass)
        superclass = klass.superclass
        superclass && superclass.name == self.name
      end
    end
  end
end
