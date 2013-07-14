require 'spec_helper'
require 'support/popcap_spec_helper'
require 'pop_cap/audio_file'

module PopCap
  describe AudioFile do

    let(:audio_file) { AudioFile.new(filepath) }
    let(:filepath) { File.realpath(PopCapSpecHelper::SAMPLE_FILE) }
    let(:included_modules) { AudioFile.included_modules }

    before { PopCapSpecHelper.setup }
    after { PopCapSpecHelper.teardown }

    subject { audio_file }

    describe '#filepath' do
      its(:filepath) { should eq File.realpath(PopCapSpecHelper::SAMPLE_FILE) }

      it 'raises an error if file does not exist' do
        expect do
          AudioFile.new('not here.file')
        end.to raise_error(FileNotFound, 'not here.file')
      end
    end

    context 'included modules' do
      it 'includes Fileable' do
        expect(included_modules).to include Fileable
      end
    end

    describe '#raw_output' do
      it 'is memoized' do
        audio_file.raw_output
        TagReader.should_not_receive(:read).with(filepath)
        audio_file.raw_output
      end

      it { expect(audio_file.raw_output).to eq(PopCapSpecHelper.raw_output) }
    end

    describe '#unformatted' do
      it 'is memoized' do
        audio_file.unformatted
        UnformattedHash.should_not_receive(:hash).with(audio_file.raw_output)
        audio_file.unformatted
      end

      it do
        expect(audio_file.unformatted).to eq PopCapSpecHelper.unformatted_hash
      end
    end

    describe '#formatted' do
      it 'is memoized' do
        audio_file.formatted
        FormattedHash.should_not_receive(:formatted).
          with(audio_file.unformatted)
        audio_file.formatted
      end

      it { expect(audio_file.formatted).to eq(PopCapSpecHelper.formatted_hash) }
    end

    describe '#tags' do
      it 'is memoized' do
        audio_file.tags
        TagStruct.should_not_receive(:new).with(audio_file.formatted)
        audio_file.tags
      end

      it 'includes all tags for the sample file' do
        PopCapSpecHelper.formatted_hash.each do |key,val|
          expect(audio_file.tags.send(key)).to eq val
        end
      end

      it 'is a TagStruct' do
        expect(audio_file.tags).to be_a TagStruct
      end
    end

    describe '#reload!' do
      it 'resets all MEMOIZABLES' do
        audio_file.tags
        audio_file.reload!
        ::MEMOIZABLES.each do |var|
          expect(audio_file.instance_variable_get(var)).to be_nil
        end
      end
    end

    describe '#update' do
      it 'reloads after tags updated' do
        audio_file.should_receive(:reload!)
        audio_file.update({foo: 'foo'})
      end

      it 'updates tags for file' do
        expect(audio_file.tags.artist).to eq 'Sample Artist'
        updates = {artist: 'New Artist'}
        audio_file.update(updates)
        expect(audio_file.tags.artist).to eq 'New Artist'
      end

      it 'returns updated hash' do
        updates = {artist: 'New Artist'}
        expect(audio_file.update(updates)).to eq audio_file.tags
      end
    end

    describe '#convert' do
      after { PopCapSpecHelper.remove_converted }

      it 'creates a new audio file with the specified format & bitrate' do
        audio_file.convert(:mp3, 128)
        expect(File.exists?('spec/fixtures/sample.mp3')).to be_true
      end
    end

    context "errors" do
      let(:bad_file_format) { "spec/fixtures/not_audio_file.jpg" }

      before { FileUtils.touch bad_file_format }
      after { FileUtils.rm_f bad_file_format }

      it "raises an error if invalid audio format" do
        expect do
          AudioFile.new(bad_file_format)
        end.to raise_error
      end
    end
  end
end
