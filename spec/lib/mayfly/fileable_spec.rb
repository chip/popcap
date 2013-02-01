require 'spec_helper'
require 'mayfly/fileable'

module Mayfly
  describe Fileable do
    class FileClass
      attr_reader :filepath

      include Fileable
      def initialize(filepath)
        @filepath = filepath
      end
    end

    let(:filepath) { 'spec/support/sample.flac' }
    let(:fc) { FileClass.new(filepath) }

    context '#filename' do
      it 'returns the basename' do
        expect(fc.filename).to eq 'sample.flac'
      end
    end

    context '#backup' do
      it 'backs up file to directory' do
        FileUtils.should_receive(:cp).with(filepath, '/tmp/sample.flac')
        fc.backup('/tmp')
      end

    end

    context '#backup_path' do
      it 'returns path from backup' do
        FileUtils.should_receive(:cp).with(filepath, '/tmp/sample.flac')
        fc.backup('/tmp')
        expect(fc.backup_path).to eq '/tmp/sample.flac'
      end

      it 'raises an error if not backed up' do
        expect{fc.backup_path}.to raise_error(PathError)
      end
    end

    context '#restore' do
      it 'restores a file from a backup path' do
        FileUtils.should_receive(:cp).with(filepath, '/tmp/sample.flac')
        fc.backup('/tmp')
        FileUtils.should_receive(:mv).with('/tmp/sample.flac', filepath)
        fc.restore
      end

      it 'raises an error if no backup path' do
        expect{fc.restore}.to raise_error(RestoreError)
      end
    end
  end
end
