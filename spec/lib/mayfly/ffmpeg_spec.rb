require 'spec_helper'
require 'support/mayfly_spec_helper'
require 'mayfly/ffmpeg'

module Mayfly
  describe FFmpeg do
    let(:commander) { double('Commander') }
    let(:filepath) { 'spec/support/sample.flac' }
    let(:ffmpeg) { FFmpeg.new(filepath) }

    it 'returns its filepath' do
      expect(ffmpeg.filepath).to eq filepath
    end

    it 'includes Fileable' do
      expect(FFmpeg.included_modules).to include Fileable
    end

    context '#read_tags' do
      it 'sends a read command to Commander' do
        command = %W{ffprobe} + %W{-show_format} + %W{#{filepath}}
        Commander.should_receive(:new).with(*command) { commander }
        commander.stub_chain(:execute, :stdout)
        ffmpeg.read_tags
      end
    end

    context '#update_tags' do
      let(:input) { %W{ffmpeg -i spec/support/sample.flac} }
      let(:new_tags) { {artist: 'New'} }

      before { MayflySpecHelper.setup }
      after { MayflySpecHelper.teardown }

      it 'updates tags on a temp file & copies temp file to original' do
        update = %W{-metadata artist=New /tmp/sample.flac}
        Commander.should_receive(:new).with(*(input + update)) { commander }
        commander.should_receive(:execute)
        ffmpeg.should_receive(:restore).with('/tmp')
        ffmpeg.update_tags(new_tags)
      end
    end
  end
end
