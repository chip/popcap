require 'spec_helper'
require 'pop_cap/converter'

module PopCap
  describe Converter do
    let(:bitrate) { %W{-ab 192k}}
    let(:command) { input + bitrate + output_path }
    let(:commander) { double('commander') }
    let(:filepath) { 'path/to/file.flac' }
    let(:input) { %W{ffmpeg -i #{filepath}} }
    let(:instance) { double('converter_instance') }

    def shared_expectation(command=command)
      commander.should_receive(:new).with(*command) { instance }
      instance.stub_chain(:execute, :success?) { true }
    end

    describe '.convert' do
      let(:output_path) { %W{path/to/file.ogg} }

      it 'has a class method for #convert' do
        shared_expectation
        Converter.convert(filepath, {format: 'ogg', commander: commander})
      end
    end

    describe '#convert' do
      let(:output_path) { %W{path/to/file.ogg} }

      context 'format' do
        it 'handles a string' do
          shared_expectation
          Converter.new(filepath, {format: 'ogg', commander: commander}).convert
        end

        it 'handles a symbol' do
          shared_expectation
          Converter.new(filepath, {format: :ogg, commander: commander}).convert
        end

        it 'is case insenstive' do
          shared_expectation
          Converter.new(filepath, {format: 'OGG', commander: commander}).convert
        end
      end

      context 'bitrate' do
        let(:output_path) { %W{path/to/file.mp3} }

        it 'defaults to 192 kb/s' do
          shared_expectation
          Converter.new(filepath, {format: :mp3, commander: commander}).convert
        end

        it 'takes an optional bitrate' do
          options = {format: :mp3, bitrate: 64, commander: commander}
          bitrate_command = input + %W{-ab 64k} + output_path
          shared_expectation(bitrate_command)
          Converter.new(filepath, options).convert
        end

        it 'handles bitrate as string' do
          options = {format: :mp3, bitrate: '128', commander: commander}
          bitrate_command = input + %W{-ab 128k} + output_path
          shared_expectation(bitrate_command)
          Converter.new(filepath, options).convert
        end
      end

      context 'm4a' do
        let(:output_path) { %W{path/to/file.m4a} }

        it 'uses strict mode' do
          strict = input + %W{-strict -2} + bitrate + output_path
          shared_expectation(strict)
          Converter.new(filepath, {format: :m4a, commander: commander}).convert
        end
      end

      context 'errors' do
        it 'raises error if could not convert file' do
          expect do
            commander.should_receive(:new).with(*command) { instance }
            instance.stub_chain(:execute, :success?) { false }
            Converter.new(filepath, {format: :ogg,
                          commander: commander}).convert
          end.to raise_error(FFmpegError, "Error converting #{filepath}.")
        end
      end
    end
  end
end
