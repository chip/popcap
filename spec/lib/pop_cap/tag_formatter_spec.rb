require 'spec_helper'
require 'pop_cap/tag_formatter'

module PopCap
  describe TagFormatter do
    class Taggy < TagFormatter
      def format; 'baz'; end
    end

    let(:taggy) { Taggy.new('foo', {option: 'bar'}) }

    describe '.format' do
      it 'wraps #format in a class method' do
        klass = Taggy.format('foo', {option: 'bar'})
        instance = taggy.format
        expect(klass).to eq instance
      end
    end

    describe '#format' do
      it { expect(taggy).to respond_to(:format) }
    end

    describe '#new' do
      it 'has a getter for value' do
        expect(taggy.value).to eq 'foo'
      end

      it 'has a getter for options' do
        expect(taggy.options).to eq({option: 'bar'})
      end
    end
  end
end
