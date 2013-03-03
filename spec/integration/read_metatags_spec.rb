require 'popcap'
require 'spec_helper'
require 'support/popcap_spec_helper'

describe PopCap do
  let(:audio_file) { PopCap::AudioFile.new(filepath) }
  let(:filepath) { PopCapSpecHelper::SAMPLE_FILE }

  it '#raw_tags' do
    expect(audio_file.raw_tags).to eq PopCapSpecHelper.raw_tags
  end
end
