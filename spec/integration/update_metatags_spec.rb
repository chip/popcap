require 'mayfly'
require 'spec_helper'
require 'support/mayfly_spec_helper'

describe Mayfly do
  let(:audio_file) { Mayfly::AudioFile.new(filepath) }
  let(:filepath) { 'spec/support/sample.flac' }

  context '#update_tags' do
    before { MayflySpecHelper.setup }
    after { MayflySpecHelper.teardown }

    it 'updates tags for file' do
      updates = {artist: 'New Artist'}
      audio_file.update_tags(updates)
      expect(audio_file.raw_tags).to match 'TAG:ARTIST=New Artist'
      expect(audio_file.raw_tags).not_to match 'TAG:ARTIST=Sample Artist'
    end
  end
end
