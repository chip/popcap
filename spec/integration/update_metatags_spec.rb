require 'popcap'
require 'spec_helper'
require 'support/popcap_spec_helper'

describe PopCap do
  let(:audio_file) { PopCap::AudioFile.new(filepath) }
  let(:filepath) { PopCapSpecHelper::SAMPLE_FILE }

  context '#update_tags' do
    before { PopCapSpecHelper.setup }
    after { PopCapSpecHelper.teardown }

    it 'updates tags for file' do
      expect(audio_file.tags.artist).to eq 'Sample Artist'
      updates = {artist: 'New Artist'}
      audio_file.update_tags(updates)
      expect(audio_file.tags.artist).to eq 'New Artist'
    end
  end
end
