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
        expect(sc.to_hash).to include(PopCapSpecHelper.to_hash)
      end

      it 'is memoized' do
        sc.to_hash
        expect(sc.instance_variable_get('@hash')).
          to include(PopCapSpecHelper.to_hash)
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
      it 'sets instance variables to nil' do
        %w(@attributes @hash @tags).each do |instance|
          sc.reload!
          expect(sc.instance_variable_get(instance)).to be_nil
        end
      end
    end
  end
end
