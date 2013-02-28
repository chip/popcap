require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/ffmpeg/ffmpeg'

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

    context '#read_tags' do
      it 'reads tags using Ffprobe' do
        expect(ffmpeg.read_tags).to eq PopCapSpecHelper.raw_tags
      end
    end

    context '#update_tags' do
      let(:new_tags) { {artist: 'UPDATEDARTIST'} }

      it 'updates tags using FFmpeg' do
        expect(ffmpeg.read_tags).to match /Sample Artist/
        ffmpeg.update_tags(new_tags)
        updated = FFmpeg.new(filepath).read_tags
        expect(updated).to match /UPDATEDARTIST/
        expect(updated).not_to match /Sample Artist/
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
