require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/tag/tag_hash'

module PopCap
  describe TagHash do
    describe '#hash' do
      let(:tag_hash) { TagHash.new(PopCapSpecHelper.raw_tags) }

      it 'symbolizes all keys' do
        tag_hash.hash.each_key do |key|
          expect(key).to be_a Symbol
        end
      end

      it 'renames filesize to size' do
        expect(tag_hash.hash[:size]).to be_nil
        expect(tag_hash.hash[:filesize]).not_to be_nil
      end

      it 'formats json output as a hash' do
        expect(tag_hash.hash).to eq(PopCapSpecHelper.unformatted_hash)
      end
    end

    describe '.hash' do
      it 'wraps #new & #hash' do
        instance = double('TagHash')
        TagHash.should_receive(:new).with('foo') { instance }
        instance.should_receive(:hash)
        TagHash.hash('foo')
      end
    end
  end
end
