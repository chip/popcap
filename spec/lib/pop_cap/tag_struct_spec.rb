require 'spec_helper'
require 'pop_cap/tag_struct'

module PopCap
  describe TagStruct do
    let(:hash) { {artist: 'Artist', date: 1984} }
    let(:ts) { TagStruct.new(hash) }

    it 'includes Enumerable' do
      expect(TagStruct.included_modules).to include(Enumerable)
    end

    describe '#new' do
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

    describe '#to_s' do
      it 'has a custom #to_s method' do
        expect(ts.to_s).to eq "#<PopCap::TagStruct artist: Artist, date: 1984>"
      end
    end

    describe '#each' do
      let(:tags) { {foo: 'foo', bar: 'bar', baz: 'baz'} }
      let(:tag_struct) { TagStruct.new tags }

      it 'has a custom #each method for all defined methods' do
        tag_struct.each do |key,val|
          expect(tags[key]).to eq val
        end
      end
    end

    describe 'already defined methods' do
      let(:tags) { {class: 'foo', hash: 'bar', inspect: 'baz'} }
      let(:tag_struct) { TagStruct.new hash }

      it 'does not set methods defined on class' do
        expect(tag_struct.class).not_to eq 'foo'
        expect(tag_struct.hash).not_to eq 'bar'
        expect(tag_struct.inspect).not_to eq 'baz'
      end
    end
  end
end
