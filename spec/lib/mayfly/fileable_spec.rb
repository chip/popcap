require 'spec_helper'
require 'mayfly/fileable'
require 'support/mayfly_spec_helper'

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
        FileUtils.should_receive(:cp).with(filepath, '/usr/sample.flac')
        fc.backup('/usr')
      end

      it 'backup directory defaults to "/tmp"' do
        FileUtils.should_receive(:cp).with(filepath, '/tmp/sample.flac')
        fc.backup
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
      it 'takes an optional path' do
        FileUtils.should_receive(:mv).with('/tmp/sample.flac', filepath)
        fc.restore('/tmp')
      end

      it 'defaults to the backup path' do
        FileUtils.should_receive(:cp).with(filepath, '/tmp/sample.flac')
        fc.backup('/tmp')
        FileUtils.should_receive(:mv).with('/tmp/sample.flac', filepath)
        fc.restore
      end
    end

    context '#tmppath' do
      it 'returns a temporary path' do
        expect(fc.tmppath).to eq '/tmp/sample.flac'
      end
    end

    context '#destroy' do
      it 'removes a file' do
        FileUtils.should_receive(:rm_f).with(filepath)
        fc.destroy
      end
    end

    context '#rename' do
      it 'removes a file with specified name' do
        new_name = 'spec/support/example.file'
        FileUtils.should_receive(:mv).with(filepath, new_name)
        fc.rename('example.file')
      end
    end

    context '#move' do
      it 'moves a file to directory' do
        destination = '/tmp'
        FileUtils.should_receive(:mv).with(filepath, destination)
        fc.move('/tmp')
      end
    end

    context '#directory' do
      it 'returns the directory path for the file' do
        expect(fc.directory).to eq 'spec/support'
      end
    end
  end
end
