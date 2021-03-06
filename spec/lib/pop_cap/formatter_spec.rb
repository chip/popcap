require 'spec_helper'
require 'pop_cap/formatter'

module PopCap
  module Formatters
    describe Formatter do
      class Filesize < Formatter
        def format; 'baz'; end
      end

      describe '.format' do
        let(:taggy) { Formatters::Filesize.new('foo', {option: 'bar'}) }

        it 'wraps #format in a class method' do
          klass = Formatters::Filesize.format('foo', {option: 'bar'})
          instance = taggy.format
          expect(klass).to eq instance
        end
      end

      describe '.subclasses' do
        it 'returns a list of all subclasses in the ObjectSpace' do
          expect(Formatter.subclasses).to include(PopCap::Formatters::Filesize)
        end

        it 'includes the subclass only once' do
          unique = Formatter.subclasses.select do |cls|
            cls == PopCap::Formatters::Filesize
          end
          expect(unique.size).to eq 1
        end

        it 'contains no nils' do
          expect(Formatter.subclasses).not_to include(nil)
        end

        it 'requires all Formatters files' do
          Formatter.subclasses
          formatters_path = '../../../../lib/pop_cap/formatters/*.rb'
          Dir[File.expand_path(formatters_path, __FILE__)].each do |file|
            expect($LOADED_FEATURES).to include(file)
          end
        end
      end

      describe '.subclasses_demodulized' do
        it 'returns of the subclasses with their names demodulized' do
          expect(Formatter.subclasses_demodulized).
            to include('Filesize')
        end
      end
    end

    describe '#format' do
      let(:taggy) { Formatters::Filesize.new('foo', {option: 'bar'}) }

      it { expect(taggy).to respond_to(:format) }
    end

    describe '#new' do
      let(:taggy) { Formatters::Filesize.new('foo', {option: 'bar'}) }

      it 'has a getter for value' do
        expect(taggy.value).to eq 'foo'
      end

      it 'has a getter for options' do
        expect(taggy.options).to eq({option: 'bar'})
      end
    end
  end
end
