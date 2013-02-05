require 'spec_helper'
require 'pop_cap/audio_file'

module PopCap
  describe AudioFile do
    let(:audio_file) { AudioFile.new(filepath) }
    let(:filepath) { 'spec/support/sample.flac' }
    let(:included_modules) { AudioFile.included_modules }

    subject { audio_file }

    context '#filepath' do
      its(:filepath) { should eq File.realpath(filepath) }

      it 'raises an error if file does not exist' do
        expect do 
          AudioFile.new('not here.file') 
        end.to raise_error(FileNotFound, 'not here.file')
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
