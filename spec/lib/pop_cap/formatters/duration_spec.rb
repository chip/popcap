require 'pop_cap/formatters/duration'
require 'spec_helper'

module PopCap
  describe Duration do
    describe '.format' do
      it 'wraps #format in a class method' do
        klass = Duration.format('128456')
        instance = Duration.new('128456').format
        expect(klass).to eq(instance)
      end
    end

    it 'formats duration as HH:MM:SS' do
      dur = Duration.new('40003')
      expect(dur.format).to eq('11:06:43')
    end

    it 'removes leading zeroes for hours' do
      dur = Duration.new('750')
      expect(dur.format).to eq('12:30')
    end

    it 'removes leading zeroes for minutes' do
      dur = Duration.new('420')
      expect(dur.format).to eq('7:00')
    end

    it 'removes leading zeroes for seconds' do
      dur = Duration.new('8')
      expect(dur.format).to eq('8')
    end

    it 'handles integers' do
      dur = Duration.new(12345)
      expect(dur.format).to eq('3:25:45')
    end

    it 'handles floats' do
      dur = Duration.new(1234.5678)
      expect(dur.format).to eq('20:34')
    end

    it 'returns warning if time greater than 24 hours' do
      dur = Duration.new('86400')
      expect(dur.format).
        to eq('Warning: Time is greater than 24 hours.')
    end

    it 'is nil if invalid number' do
      dur = Duration.new('string')
      expect(dur.format).to be_nil
    end

    it 'is nil if nil' do
      dur = Duration.new(nil)
      expect(dur.format).to be_nil
    end

    it 'is nil if empty string' do
      dur = Duration.new('')
      expect(dur.format).to be_nil
    end

    it 'is nil if zero' do
      dur = Duration.new(0)
      expect(dur.format).to be_nil
    end
  end
end
