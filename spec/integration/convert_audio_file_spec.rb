require 'spec_helper'
require 'support/mayfly_spec_helper'
require 'mayfly/audio_file'

module Mayfly
  describe 'Convert Audio Files' do
    after { MayflySpecHelper.remove_converted }

    it 'creates a new audio file with the specified format & bitrate' do
      audio_file = AudioFile.new('spec/support/sample.flac')
      audio_file.convert(:mp3, 128)
      expect(File.exists?('spec/support/sample.mp3')).to be_true
    end
  end
end