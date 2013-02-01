require 'spec_helper'
require 'mayfly/ffmpeg'

module Mayfly
  describe FFmpeg do
    let(:filepath) { 'spec/support/sample.flac' }
    let(:ffmpeg) { FFmpeg.new(filepath) }

    it 'sends a read command to Commander' do
      commander = double('Commander')
      executed = double('executed')
      command = %W{ffprobe} + %W{-show_format} + %W{#{filepath}}
      Commander.should_receive(:new).with(*command) { commander }
      commander.should_receive(:execute) { executed }
      executed.should_receive(:stdout)
      ffmpeg.read_tags
    end
  end
end
