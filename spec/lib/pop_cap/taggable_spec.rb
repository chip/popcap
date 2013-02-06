require 'spec_helper'
require 'support/popcap_spec_helper'
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

      it 'is memoized' do
        sc.to_hash
        expect(sc.instance_variable_get('@to_hash')).
          to eq PopCapSpecHelper.to_hash
      end
    end

    context '#tags' do
      it 'builds an OpenStruct of Formatted tags from a hash' do
        expect(sc.tags).to eq PopCapSpecHelper.tags
      end

      it 'is memoized' do
        sc.tags
        expect(sc.instance_variable_get('@tags')).
          to eq PopCapSpecHelper.tags
      end
    end

    context '#reload!' do
      it 'reloads #to_hash' do
        sc.to_hash
        sc.reload!(nil)
        expect(sc.instance_variable_get('@to_hash')).to be_nil
      end

      it 'reloads #tags' do
        sc.tags
        sc.reload!(nil)
        expect(sc.instance_variable_get('@tags')).to be_nil
      end

      it 'does nothing if #raw_tags is not nil' do
        expect(sc.reload!('foo')).to be_false
      end
    end
  end
end
