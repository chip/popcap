module PopCap
  # Public: This is a super class for all formatter classes.
  # It establishes the default behavior of formatter classes.
  #
  module Formatters
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
        ObjectSpace.each_object(Class).map do |klass| 
          klass if is_a_subclass?(klass)
        end.uniq.compact
      end

      # Public: This returns an array of all subclasses "demodulized."
      #
      def self.subclasses_demodulized
        subclasses.map { |klass| demodulize(klass) }
      end

      private
      def self.demodulize(klass)
        klass.to_s.split('::').last
      end

      def self.is_a_subclass?(klass)
        klass.superclass && klass.superclass.name == self.name
      end
    end
  end
end
