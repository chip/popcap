require 'spec_helper'
require 'pop_cap/ffmpeg/tag_writer'

module PopCap
  describe TagWriter do
    let(:commander) { double('commander') }
    let(:instance) { double('commander_instance') }
    let(:file) { 'path/to/file.flac' }
    let(:tags) { {artist: 'UPDATE'} }
    let(:writer) { TagWriter.new(file, tags, commander) }

    let(:command) do
      %W{ffmpeg -i #{file} -metadata artist=UPDATE /tmp/file.flac}
    end

    describe '.write' do
      it 'has a class method for #write' do
        TagWriter.should_receive(:new).with(file, tags, commander) { instance }
        instance.should_receive(:write)
        TagWriter.write(file, tags, commander)
      end
    end

    describe '#write' do
      it 'updates tags to a temp file' do
        commander.should_receive(:new).with(*command) { instance }
        instance.stub_chain(:execute, :success?) { true }
        FileUtils.stub(:move)
        writer.write
      end

      it 'moves temp file to original' do
        commander.should_receive(:new).with(*command) { instance }
        instance.stub_chain(:execute, :success?) { true }
        FileUtils.should_receive(:move).with('/tmp/file.flac', file)
        writer.write
      end

      context 'errors' do
        it 'raises FFmpegError if could not update tags' do
          expect do
            commander.should_receive(:new).with(*command) { instance }
            instance.stub_chain(:execute, :success?) { false }
            writer.write
          end.to raise_error(FFmpegError, "Error updating #{file}")
        end

        it 'does not move temp file' do
          expect do
            commander.should_receive(:new).with(*command) { instance }
            instance.stub_chain(:execute, :success?) { false }
            FileUtils.should_not_receive(:move).with('/tmp/file.flac', file)
            writer.write
          end.to raise_error(FFmpegError, "Error updating #{file}")
        end
      end
    end
  end
end
