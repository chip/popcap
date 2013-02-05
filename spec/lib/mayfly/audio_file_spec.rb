require 'spec_helper'
require 'mayfly/audio_file'

module Mayfly
  describe AudioFile do
    let(:audio_file) { AudioFile.new(filepath) }
    let(:filepath) { 'spec/support/sample.flac' }
    let(:included_modules) { AudioFile.included_modules }

    subject { audio_file }

    context '#filepath' do
      its(:filepath) { should eq filepath }

      it 'raises an error if file does not exist' do
        expect { AudioFile.new('not here.file') }.to raise_error(FileNotFound)
      end
    end

    context 'ffmpeg methods' do
      it { expect(audio_file).to respond_to(:convert) }
      it { expect(audio_file).to respond_to(:raw_tags) }
      it { expect(audio_file).to respond_to(:update_tags) }
    end

    context 'included modules' do
      it 'includes Fileable' do
        expect(included_modules).to include Fileable
      end

      it 'includes Taggable' do
        expect(included_modules).to include Taggable
      end
    end
  end
end
