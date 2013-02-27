require 'spec_helper'
require 'pop_cap/ffmpeg/tag_reader'

module PopCap
  describe TagReader do
    let(:commander) { double('commander') }
    let(:instance) { double('commander_instance') }
    let(:file) { 'path/to/file.flac' }
    let(:reader) { TagReader.new(file, commander) }
    let(:command) { %W{ffprobe -show_format #{file}} }

    let(:shared) do
      commander.should_receive(:new).with(*command) { instance }
      instance.stub_chain(:execute, :success?) { true }
      instance.stub_chain(:execute, :stdout) { instance }
    end

    describe '.read' do
      it 'has a class method for #read' do
        shared
        instance.stub(:valid_encoding?) { true }
        TagReader.read(file, commander)
      end
    end

    describe '#read' do
      before { shared }
      after { reader.read }

      it 'does not encode valid byte strings' do
        instance.stub(:valid_encoding?) { true }
        instance.should_not_receive(:encode!)
      end

      it 'encodes invalid byte strings as UTF-8' do
        instance.stub(:valid_encoding?) { false }
        instance.stub_chain(:encoding, :name) { 'UTF-8' }
        instance.should_receive(:encode!).
          with('UTF-16', 'UTF-8', undef: :replace, invalid: :replace)
        instance.should_receive(:encode!).with('UTF-8')
      end
    end

    context 'errors' do
      it 'raises error if could not read tags' do
        expect do
          commander.should_receive(:new).with(*command) { instance }
          instance.stub_chain(:execute, :success?) { false }
          reader.read
        end.to raise_error(FFmpegError, "Error reading #{file}")
      end
    end
  end
end
