require 'spec_helper'
require 'pop_cap/tag_struct'

module PopCap
  describe TagStruct do
    let(:hash) { {artist: 'Artist', date: 1984} }
    let(:ts) { TagStruct.new(hash) }

    context '#new' do
      it 'raises error if not a hash' do
        expect do
          TagStruct.new(Array)
        end.to raise_error(ArgumentError, 'Initialize with a hash.')
      end
    end

    it 'defines methods for the hash keys' do
      hash.keys.each do |key|
        expect(ts.send(key)).to be_true
      end
    end

    it 'sets hash value to method' do
      hash.each do |key, val|
        expect(ts.send(key)).to eq val
      end
    end

    it 'responds to the methods' do
      hash.keys.each do |key|
        expect(ts).to respond_to(key)
      end
    end

    it 'has a custom #to_s method' do
      expect(ts.to_s).to eq "#<PopCap::TagStruct artist: Artist, date: 1984>"
    end
  end
end
