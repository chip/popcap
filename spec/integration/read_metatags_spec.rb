require 'mayfly'
require 'spec_helper'
require 'support/mayfly_spec_helper'

describe Mayfly do
  let(:audio_file) { Mayfly::AudioFile.new(filepath) }
  let(:filepath) { 'spec/support/sample.flac' }

  it '#raw_tags' do
    expect(audio_file.raw_tags).to eq MayflySpecHelper.raw_tags
  end

  it '#to_hash' do
    expect(audio_file.to_hash).to eq MayflySpecHelper.to_hash
  end

  it '#tags' do
    expect(audio_file.tags).to eq MayflySpecHelper.tags
  end
end
