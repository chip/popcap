require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/ffmpeg'

module PopCap
  describe FFmpeg do
    let(:commander) { double('Commander') }
    let(:filepath) { 'spec/support/sample.flac' }
    let(:ffmpeg) { FFmpeg.new(filepath) }

    it 'returns its filepath' do
      expect(ffmpeg.filepath).to eq filepath
    end
    
    it 'raises error if FFmpeg not installed' do
      error_message = 'No such file or directory - FFmpeg is not installed.'
      expect do
        Open3.stub(:capture3).with('ffmpeg').and_raise(Errno::ENOENT)
        FFmpeg.new('filepath')
      end.to raise_error(MissingDependency, error_message)
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

      it 'updates tags on a temp file & copies temp file to original' do
        update = %W{-metadata artist=New /tmp/sample.flac}
        Commander.should_receive(:new).with(*(input + update)) { commander }
        commander.should_receive(:execute)
        ffmpeg.should_receive(:restore).with('/tmp')
        ffmpeg.update_tags(new_tags)
      end
    end

    context '#convert' do
      it 'converts from input format to specified output format & bitrate' do
        input = %W{ffmpeg -i spec/support/sample.flac}
        options = %W{-ab 64k}
        output = %W{spec/support/sample.mp3}
        Commander.should_receive(:new).with(*(input + options + output)).
          and_return(commander)
        commander.should_receive(:execute)
        ffmpeg.convert(:mp3, 64)
      end
    end
  end
end
