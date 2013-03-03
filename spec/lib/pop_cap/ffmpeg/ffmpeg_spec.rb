require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/ffmpeg/ffmpeg'

module PopCap
  describe FFmpeg do

    let(:filepath) { File.realpath(PopCapSpecHelper::SAMPLE_FILE) }
    let(:ffmpeg) { FFmpeg.new(filepath) }

    it 'returns its filepath' do
      expect(ffmpeg.filepath).to eq filepath
    end

    it 'sets default commander to Commander' do
      expect(ffmpeg.commander).to eq Commander
    end

    it '#new takes an options hash' do
      opts = {foo: 'foo'}
      ffmpeg = FFmpeg.new(filepath, opts)
      expect(ffmpeg.options).to eq({foo: 'foo'})
    end

    it 'has a custom error message' do
      expect(ffmpeg.error_message('loving')).to eq "Error loving #{filepath}."
    end

    it 'raises error if FFmpeg not installed' do
      error_message = 'No such file or directory - FFmpeg is not installed.'
      expect do
        Open3.stub(:capture3).with('ffmpeg').and_raise(Errno::ENOENT)
        FFmpeg.new('filepath')
      end.to raise_error(MissingDependency, error_message)
    end
  end
end
