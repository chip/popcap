require 'spec_helper'
require 'pop_cap/ffmpeg/tag_reader'

module PopCap
  describe TagReader do
    let(:commander) { double('commander') }
    let(:instance) { double('commander_instance') }
    let(:file) { 'path/to/file.flac' }
    let(:reader) { TagReader.new(file, {commander: commander}) }
    let(:command) { %W{ffprobe -show_format -print_format json #{file}} }

    let(:shared_example) do
      commander.should_receive(:new).with(*command) { instance }
      instance.stub_chain(:execute, :success?) { true }
      instance.stub_chain(:execute, :stdout) { instance }
    end

    it 'test' do
      puts JSON.parse(TagReader.read('spec/fixtures/sample.flac'))
    end

    describe '.read' do
      before { shared_example }

      it 'has a class method for #read' do
        instance.stub(:valid_encoding?) { true }
        JSON.stub(:load)
        TagReader.read(file, {commander: commander})
      end
    end

    describe '#read' do
      before { shared_example }
      after { reader.read }

      it 'returns the output as JSON' do
        instance.stub(:valid_encoding?) { true }
        JSON.should_receive(:load).with(instance) { instance }
        instance.should_receive(:to_json)
      end

      it 'does not encode valid byte strings' do
        instance.stub(:valid_encoding?) { true }
        JSON.stub(:load)
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
        end.to raise_error(FFmpegError, "Error reading #{file}.")
      end
    end
  end
end
