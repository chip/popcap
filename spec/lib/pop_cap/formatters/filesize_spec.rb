require 'spec_helper'
require 'pop_cap/formatters/filesize'

module PopCap
  module Formatters
    describe Filesize do
      it 'uses binary conversion' do
        fs = Filesize.new('1024')
        expect(fs.format).to eq '1K'
      end

      it 'uses "B" for bytes' do
        fs = Filesize.new(204)
        expect(fs.format).to eq '204B'
      end

      it 'uses "K" for kilobytes' do
        fs = Filesize.new(2048)
        expect(fs.format).to eq '2K'
      end

      it 'uses "M" for megabytes' do
        fs = Filesize.new(2048000)
        expect(fs.format).to eq '2M'
      end

      it 'uses "G" for gigabytes' do
        fs = Filesize.new(2148000000)
        expect(fs.format).to eq '2G'
      end

      it 'uses "T" for terabytes' do
        fs = Filesize.new(2148000000000)
        expect(fs.format).to eq '2T'
      end

      it 'returns a warning if larger than 999 terabytes' do
        fs = Filesize.new(1099500000000000)
        expect(fs.format).
          to eq 'Warning: Number is larger than 999 terabytes.'
      end

      it 'rounds to nearest tenth' do
        fs = Filesize.new(63587)
        expect(fs.format).to eq '62.1K'
      end

      it 'drops tenth if it is zero' do
        fs = Filesize.new(4096)
        expect(fs.format).to eq '4K'
      end

      it 'handles strings' do
        fs = Filesize.new('123456')
        expect(fs.format).to eq '120.6K'
      end

      it 'handles integers' do
        fs = Filesize.new(123456)
        expect(fs.format).to eq '120.6K'
      end

      it 'handles floats' do
        fs = Filesize.new(1234.56)
        expect(fs.format).to eq '1.2K'
      end

      it 'returns nil for nil' do
        fs = Filesize.new(nil)
        expect(fs.format).to be_nil
      end

      it 'returns nil for empty string' do
        fs = Filesize.new('')
        expect(fs.format).to be_nil
      end

      it 'returns nil if not a number' do
        fs = Filesize.new('hello')
        expect(fs.format).to be_nil
      end

      it 'returns nil if zero' do
        fs = Filesize.new(0)
        expect(fs.format).to be_nil
      end
    end
  end
end
