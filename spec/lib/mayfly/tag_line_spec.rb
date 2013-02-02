require 'spec_helper'
require 'mayfly/tag_line'

module Mayfly
  describe TagLine do
    it 'builds a hash by splitting on first equal sign' do
      tl = TagLine.new('one=two=four')
      expect(tl.to_hash).to eq({one: 'two=four'})
    end

    it 'returns an empty hash for empty string' do
      tl = TagLine.new('')
      expect(tl.to_hash).to eq({})
    end

    it 'returns an empty hash for nil' do
      tl = TagLine.new(nil)
      expect(tl.to_hash).to eq({})
    end

    it 'return an empty hash if no equal sign in string' do
      tl = TagLine.new('onetwofour')
      expect(tl.to_hash).to eq({})
    end
  end
end
