require 'spec_helper'
require 'pop_cap/tag/unformatted_tag'

module PopCap
  describe UnformattedTag do
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
