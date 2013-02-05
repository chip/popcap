require 'spec_helper'
require 'pop_cap/converter'

module PopCap
  describe Converter do
    class FakeClass
      include Converter
      def filepath
        'path/to/file.flac'
      end
    end

    let(:filepath) { 'path/to/file.flac' }
    let(:fk) { FakeClass.new }
    let(:input) { %W{ffmpeg -i #{filepath}} }

    context '#command' do
      let(:output_path) { %W{path/to/file.ogg} }

      it 'builds a command' do
        expect(fk.convert('ogg')).to eq(input + output_path)
      end

      context 'format' do
        it 'handles symbol' do
          expect(fk.convert(:ogg)).to eq(input + output_path)
        end

        it 'is case insenstive' do
          expect(fk.convert('OGG')).to eq(input + output_path)
        end
      end

      context 'bitrate' do
        let(:output_path) { %W{path/to/file.mp3} }

        it 'defaults to 192 kb/s' do
          expect(fk.convert(:mp3)).to eq(input + %W{-ab 192k} + output_path)
        end

        it 'takes an optional bitrate' do
          expect(fk.convert(:mp3, 64)).to eq(input + %W{-ab 64k} + output_path)
        end

        it 'handles bitrate as string' do
          expect(fk.convert(:mp3, '128')).
            to eq(input + %W{-ab 128k} + output_path)
        end

        it 'ignores bitrate if format is not mp3' do
          expect(fk.convert(:ogg, 128)).to eq(input + %W{path/to/file.ogg})
        end
      end

      context 'm4a' do
        let(:output_path) { %W{path/to/file.m4a} }

        it 'uses strict mode' do
          expect(fk.convert(:m4a)).to eq(input + %W{-strict -2} + output_path)
        end

        it 'ignores strict mode if not m4a' do
          expect(fk.convert(:ogg)).to eq(input + %W{path/to/file.ogg})
        end
      end

      context 'errors' do
        it 'raises BitRateConversionError if invalid bitrate' do
          expect{fk.convert(:mp3, 'foo')}.to raise_error(BitRateConversionError)
        end

        it 'raises FormatConversionError if invalid format' do
          expect{fk.convert(:foo)}.to raise_error(FormatConversionError)
        end
      end
    end
  end
end
