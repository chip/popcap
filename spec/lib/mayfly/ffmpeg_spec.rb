require 'spec_helper'
require 'support/mayfly_spec_helper'
require 'mayfly/ffmpeg'

module Mayfly
  describe FFmpeg do
    let(:ffmpeg) { FFmpeg.new('spec/support/sample.flac' ) }

    it 'reads tags from a file' do
      expect(ffmpeg.read_tags).to eq MayflySpecHelper.raw_tags
    end
  end
end
