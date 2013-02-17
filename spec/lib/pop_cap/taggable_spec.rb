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
        expect(sc.instance_variable_get('@hash')).
          to eq PopCapSpecHelper.to_hash
      end
    end

    context '#tags' do
      it 'builds a tag structure of from a hash' do
        expect(sc.tags.album).to eq PopCapSpecHelper.tags.album
        expect(sc.tags.artist).to eq PopCapSpecHelper.tags.artist
        expect(sc.tags.bit_rate).to eq PopCapSpecHelper.tags.bit_rate
        expect(sc.tags.date).to eq PopCapSpecHelper.tags.date
        expect(sc.tags.duration).to eq PopCapSpecHelper.tags.duration
        expect(sc.tags.filename).to eq PopCapSpecHelper.tags.filename
        expect(sc.tags.filesize).to eq PopCapSpecHelper.tags.filesize
        expect(sc.tags.format_name).to eq PopCapSpecHelper.tags.format_name
        expect(sc.tags.genre).to eq PopCapSpecHelper.tags.genre
        expect(sc.tags.title).to eq PopCapSpecHelper.tags.title
        expect(sc.tags.track).to eq PopCapSpecHelper.tags.track
      end

      it 'is memoized' do
        sc.tags
        expect(sc.instance_variable_get('@tags')).to be_true
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
