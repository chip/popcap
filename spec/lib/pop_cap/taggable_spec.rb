require 'spec_helper'
require 'support/pop_cap_spec_helper'
require 'pop_cap/taggable'

module PopCap
  describe Taggable do
    class SomeClass
      include Taggable
      def raw_tags
        PopCapSpecHelper.raw_tags
      end
    end

    let(:sc) { SomeClass.new }

    it 'has #raw_tags' do
      expect(sc).to respond_to(:raw_tags)
    end

    context '#to_hash' do
      it 'builds a sanitized hash from FFmpeg raw_tags' do
        expect(sc.to_hash).to eq PopCapSpecHelper.to_hash
      end
    end

    context '#tags' do
      it 'builds an OpenStruct of Formatted tags from a hash' do
        expect(sc.tags).to eq PopCapSpecHelper.tags
      end
    end
  end
end
