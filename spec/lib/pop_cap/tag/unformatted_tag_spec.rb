require 'spec_helper'
require 'pop_cap/tag/unformatted_tag'

module PopCap
  describe UnformattedTag do
    describe '.to_hash' do
      it 'wraps #new & #to_hash' do
        tag = double('UnformattedTag')
        UnformattedTag.should_receive(:new).with('one=two') { tag }
        tag.should_receive(:to_hash)
        UnformattedTag.to_hash('one=two')
      end
    end

    describe '#to_hash' do
      it 'builds a hash by splitting on first equal sign' do
        tag = UnformattedTag.new('one=two=four')
        expect(tag.to_hash).to eq({one: 'two=four'})
      end

      it 'returns an empty hash for empty string' do
        tag = UnformattedTag.new('')
        expect(tag.to_hash).to eq({})
      end

      it 'returns an empty hash for nil' do
        tag = UnformattedTag.new(nil)
        expect(tag.to_hash).to eq({})
      end

      it 'return an empty hash if no equal sign in string' do
        tag = UnformattedTag.new('onetwofour')
        expect(tag.to_hash).to eq({})
      end
    end
  end
end
