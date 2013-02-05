require 'pop_cap'
require 'spec_helper'
require 'support/pop_cap_spec_helper'

describe PopCap do
  let(:audio_file) { PopCap::AudioFile.new(filepath) }
  let(:filepath) { 'spec/support/sample.flac' }

  it '#raw_tags' do
    expect(audio_file.raw_tags).to eq PopCapSpecHelper.raw_tags
  end

  it '#to_hash' do
    expect(audio_file.to_hash).to eq PopCapSpecHelper.to_hash
  end

  it '#tags' do
    expect(audio_file.tags).to eq PopCapSpecHelper.tags
  end
end
