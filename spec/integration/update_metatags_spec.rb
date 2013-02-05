require 'popcap'
require 'spec_helper'
require 'support/popcap_spec_helper'

describe PopCap do
  let(:audio_file) { PopCap::AudioFile.new(filepath) }
  let(:filepath) { 'spec/support/sample.flac' }

  context '#update_tags' do
    before { PopCapSpecHelper.setup }
    after { PopCapSpecHelper.teardown }

    it 'updates tags for file' do
      updates = {artist: 'New Artist'}
      audio_file.update_tags(updates)
      expect(audio_file.raw_tags).to match 'TAG:ARTIST=New Artist'
      expect(audio_file.raw_tags).not_to match 'TAG:ARTIST=Sample Artist'
    end
  end
end
