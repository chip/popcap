require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/unformatted_hash'

module PopCap
  describe UnformattedHash do
    describe '#hash' do
      let(:json) { '{"format":{"size":"10","tags":{"artist":"artist"}}}' }
      let(:unformatted_hash) do
        UnformattedHash.new(PopCapSpecHelper.raw_output)
      end

      it 'symbolizes all keys' do
        unformatted_hash.hash.each_key do |key|
          expect(key).to be_a Symbol
        end
      end

      it 'renames filesize to size' do
        expect(unformatted_hash.hash[:size]).to be_nil
        expect(unformatted_hash.hash[:filesize]).not_to be_nil
      end

      it 'formats json output as a hash' do
        expect(unformatted_hash.hash).to be_a Hash
      end

      it 'merges tags section with format section' do
        unformatted = UnformattedHash.new(json)
        expect(unformatted.hash).to eq({filesize: '10', artist: 'artist'})
      end

      context "JSON does not contain 'tags' element" do
        let(:json) { '{"format":{"size":"10"}}' }

        it "returns a valid #unformatted hash" do
          unformatted = UnformattedHash.new(json)
          expect(unformatted.hash).to eq({filesize: '10'})
        end
      end
    end

    describe '.hash' do
      it 'wraps #new & #hash' do
        instance = double('UnformattedHash')
        UnformattedHash.should_receive(:new).with('foo') { instance }
        instance.should_receive(:hash)
        UnformattedHash.hash('foo')
      end
    end
  end
end
