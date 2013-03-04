require 'spec_helper'
require 'pop_cap/formatted_hash'

module PopCap
  describe FormattedHash do
    describe '.formatted' do
      it 'wraps #new & #formatted' do
        instance = double('FormattedHash')
        FormattedHash.should_receive(:new).with('foo') { instance }
        instance.should_receive(:formatted)
        FormattedHash.formatted('foo')
      end
    end

    describe '#formatted' do
      it 'does not return the formatter element, if not supplied' do
        hash = FormattedHash.new(filesize: 123456)
        expect(hash.formatted).not_to have_key(:date)
      end

      it 'applies a formatter if it is in the supplied hash' do
        hash = FormattedHash.new(filesize: 123456)
        expect(hash.formatted).to eq(filesize: '120.6K')
      end

      it 'merges in non-formattable attributes' do
        hash = FormattedHash.new({filesize: 123456, artist: 'foo'})
        expect(hash.formatted).to eq({filesize: '120.6K', artist: 'foo'})
      end
    end
  end
end
