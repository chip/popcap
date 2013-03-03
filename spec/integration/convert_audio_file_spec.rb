require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/audio_file'

module PopCap
  describe 'Convert Audio Files' do
    after { PopCapSpecHelper.remove_converted }

    it 'creates a new audio file with the specified format & bitrate' do
      audio_file = AudioFile.new(PopCapSpecHelper::SAMPLE_FILE)
      audio_file.convert(:mp3, 128)
      expect(File.exists?('spec/fixtures/sample.mp3')).to be_true
    end
  end
end
