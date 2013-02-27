require 'pop_cap/formatters/date'
require 'spec_helper'

module PopCap
  describe Date do
    describe '.format' do
      it 'wraps #format in a class method' do
        klass = Date.format('1975')
        instance = Date.new('1975').format
        expect(klass).to eq(instance)
      end
    end

    it 'handles dates like "October 5, 1975"' do
      dm = Date.new('October 5, 1975')
      expect(dm.format).to eq 1975
    end

    it 'handles dates like "10-05-1984"' do
      dm = Date.new('10-05-1984')
      expect(dm.format).to eq 1984
    end

    it 'handles dates like "1993/10/05"' do
      dm = Date.new('1993/10/05')
      expect(dm.format).to eq 1993
    end

    it 'handles dates like 2012' do
      dm = Date.new(2012)
      expect(dm.format).to eq 2012
    end

    it 'returns an integer' do
      dm = Date.new(1953)
      expect(dm.format).to be_a Integer
    end

    context 'date range' do
      it 'takes an optional start date range' do
        dm = Date.new(1961, {start_date: 1900})
        expect(dm.start_date).to eq(1900)
      end

      it 'takes an optional end date range' do
        dm = Date.new(1961, {end_date: 3000})
        expect(dm.end_date).to eq(3000)
      end

      it 'defaults to 1800 for start date' do
        dm = Date.new(1961)
        expect(dm.start_date).to eq(1800)
      end

      it 'defaults to 2100 for end date' do
        dm = Date.new(1961)
        expect(dm.end_date).to eq(2100)
      end

      it 'returns nil if beyond date range' do
        dm = Date.new(1799)
        expect(dm.format).to be_nil
      end

      it 'returns nil if under date range' do
        dm = Date.new(2101)
        expect(dm.format).to be_nil
      end
    end
    it 'returns nil if no match' do
      dm = Date.new(123)
      expect(dm.format).to be_nil
    end

    it 'returns nil if ambiguous' do
      dm = Date.new(19751005)
      expect(dm.format).to be_nil
    end
  end
end
