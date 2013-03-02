require 'spec_helper'
require 'pop_cap/tag/tag_key'

module PopCap
  describe TagKey do
    context '#format' do
      it 'is downcased' do
        expect(TagKey.new('UPCASE').format).to eq(:upcase)
      end

      it 'is symbolized' do
        expect(TagKey.new('symbol').format).to eq(:symbol)
      end

      it 'removes "TAG:" if at beginning of string' do
        expect(TagKey.new('TAG:artist').format).to eq(:artist)
      end

      it 'does remove "TAG:" if not at beginning of string' do
        expect(TagKey.new('TAG:fooTAG:').format).to eq(:"footag:")
      end

      it 'renames "size" to "filesize" if at beginning of line' do
        expect(TagKey.new('size').format).to eq(:filesize)
      end

      it 'does not rename "size" to "filesize" if not at beginning of line' do
        expect(TagKey.new('cosize').format).to eq(:cosize)
      end

      it 'renames "size" to "filesize" if word boundary' do
        expect(TagKey.new('size dot').format).to eq(:"filesize dot")
      end

      it 'does not rename "size" to "filesize" if not word boundary' do
        expect(TagKey.new('sizedot').format).to eq(:sizedot)
      end

      it 'returns empty string if empty' do
        expect(TagKey.new('').format).to eq('')
      end

      it 'returns empty string if nil' do
        expect(TagKey.new(nil).format).to eq('')
      end
    end
  end
end
