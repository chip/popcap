require 'mayfly'
require 'spec_helper'
require 'support/mayfly_spec_helper'

describe Mayfly do
  let(:audio_file) { Mayfly::AudioFile.new(filepath) }
  let(:filepath) { 'spec/support/sample.flac' }

  it '#raw_tags' do
    expect(audio_file.raw_tags).to eq MayflySpecHelper.raw_tags
  end
end
