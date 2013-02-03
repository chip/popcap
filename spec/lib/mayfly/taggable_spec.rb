require 'spec_helper'
require 'support/mayfly_spec_helper'
require 'mayfly/taggable'

module Mayfly
  describe Taggable do
    class SomeClass
      include Taggable
      def raw_tags
        MayflySpecHelper.raw_tags
      end
    end

    let(:sc) { SomeClass.new }

    it 'has #raw_tags' do
      expect(sc).to respond_to(:raw_tags)
    end

    context '#to_hash' do
      it 'builds a sanitized hash from FFmpeg raw_tags' do
        expect(sc.to_hash).to eq MayflySpecHelper.to_hash
      end
    end

    context '#tags' do
      it 'builds an OpenStruct of Formatted tags from a hash' do
        expect(sc.tags).to eq MayflySpecHelper.tags
      end
    end
  end
end
