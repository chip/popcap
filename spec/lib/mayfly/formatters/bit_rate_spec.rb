require 'mayfly/formatters/bit_rate'

module Mayfly
  module Formatters
    describe BitRate do
      it 'makes bitrate human readable' do
        br = BitRate.new(128456)
        expect(br.format_bit_rate).to eq('128 kb/s')
      end

      it 'handles strings' do
        br = BitRate.new('128456')
        expect(br.format_bit_rate).to eq('128 kb/s')
      end

      it 'handles long bitrates' do
        br = BitRate.new('1284567')
        expect(br.format_bit_rate).to eq('1284 kb/s')
      end

      it 'handles short bitrates' do
        br = BitRate.new('64845')
        expect(br.format_bit_rate).to eq('64 kb/s')
      end

      it 'formats as kilobytes' do
        br = BitRate.new('64845')
        expect(br.format_bit_rate).to match(/kb\/s/)
      end

      it 'is nil if empty string' do
        br = BitRate.new('')
        expect(br.format_bit_rate).to be_nil
      end

      it 'is nil if nil' do
        br = BitRate.new(nil)
        expect(br.format_bit_rate).to be_nil
      end

      it 'is nil if not a number' do
        br = BitRate.new('foo')
        expect(br.format_bit_rate).to be_nil
      end

      it 'is not greater than zero' do
        br = BitRate.new(0)
        expect(br.format_bit_rate).to be_nil
      end
    end
  end
end
