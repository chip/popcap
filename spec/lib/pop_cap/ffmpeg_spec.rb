require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/ffmpeg'

module PopCap
  describe FFmpeg do
    before { PopCapSpecHelper.setup }
    after { PopCapSpecHelper.teardown }

    let(:commander) { double('Commander') }
    let(:filepath) { File.realpath('spec/support/sample.flac') }
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
      let(:output) { double('output') }

      it 'sends a read command to Commander' do
        expect(ffmpeg.read_tags).to eq PopCapSpecHelper.raw_tags
      end

      it 'encodes invalid byte strings as UTF-8' do
        Commander.stub_chain(:new, :execute) { output }
        output.should_receive(:success?) { true }
        output.should_receive(:stdout) { output }
        output.stub(:valid_encoding?) { false }
        output.stub_chain(:encoding, :name) { 'UTF-8' }
        output.should_receive(:encode!).
          with('UTF-16', 'UTF-8', undef: :replace, invalid: :replace)
        output.should_receive(:encode!).with('UTF-8')
        ffmpeg.read_tags
      end

      it 'raises error if could not read tags' do
        expect do
          failed = double('commander', :success? => false)
          Commander.stub_chain(:new, :execute) { failed }
          ffmpeg.read_tags
        end.
          to raise_error(FFmpegError, 'Error reading ' + filepath)
      end
    end

    context '#update_tags' do
      let(:new_tags) { {artist: 'UPDATEDARTIST'} }

      it 'updates tags on a temp file & copies temp file to original' do
        expect(ffmpeg.read_tags).to match /Sample Artist/
        ffmpeg.update_tags(new_tags)
        expect(ffmpeg.read_tags).to match /UPDATEDARTIST/
        expect(ffmpeg.read_tags).not_to match /Sample Artist/
      end

      it 'reloads read_tags' do
        ffmpeg.read_tags
        Commander.stub_chain(:new, :execute).
          and_return(double('output', success?: true))
        ffmpeg.stub(:restore)
        ffmpeg.update_tags({})
        expect(ffmpeg.instance_variable_get('@stdout')).to be_nil
      end

      it 'raises error if could not update tags' do
        expect do
          failed = double('commander', :success? => false)
          Commander.stub_chain(:new, :execute) { failed }
          ffmpeg.update_tags({})
        end.
          to raise_error(FFmpegError, 'Error updating ' + filepath)
      end
    end

    context '#convert' do
      it 'converts from input format to specified output format & bitrate' do
        ffmpeg.convert(:mp3, 64)
        mp3 = FFmpeg.new(File.realpath('spec/support/sample.mp3'))
        expect(mp3.read_tags).to match /format_name=mp3/
      end
    end
  end
end
