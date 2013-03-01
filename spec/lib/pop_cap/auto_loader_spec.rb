require 'spec_helper'
require 'pop_cap/auto_loader'
require 'fileutils'

module PopCap
  describe AutoLoader do
    let(:directory) { 'fake_dir' }
    let(:loader) { AutoLoader.new(directory) }

    before do
      FileUtils.mkdir directory
      FileUtils.touch directory + '/foo.rb'
      FileUtils.touch directory + '/bar.rb'
      FileUtils.touch directory + '/baz.yml'
    end

    after { FileUtils.rm_rf 'fake_dir' }

    describe '.require_all' do
      it 'wraps #require_all' do
        loader = double('loader')
        AutoLoader.should_receive(:new).with(directory) { loader }
        loader.should_receive(:require_all)
        AutoLoader.require_all(directory)
      end
    end

    describe "#directory" do
      it 'adds a trailing slash to the directory' do
        expect(AutoLoader.new('home').directory).to eq 'home/'
      end

      it 'does not add the trailing slash if it already has one' do
        expect(AutoLoader.new('home/').directory).to eq 'home/'
      end
    end

    describe '#require_all' do
      it 'requires all Ruby files' do
        loader.require_all

        %w(foo.rb bar.rb).each do |file|
          filepath = File.realpath('fake_dir/' + file)
          expect($LOADED_FEATURES).to include(filepath)
        end
      end

      it 'does not require non Ruby files' do
        loader.require_all
        filepath = File.realpath('fake_dir/baz.yml')
        expect($LOADED_FEATURES).not_to include(filepath)
      end

      it 'returns itself' do
        expect(loader.require_all).to eq loader
      end
    end

    describe '#loaded_paths' do
      it 'returns a hash of file names & paths for loaded files' do
        expect(loader.loaded_paths).to include({bar: 'fake_dir/bar'})
        expect(loader.loaded_paths).to include({foo: 'fake_dir/foo'})
      end

      it 'excludes non loaded files' do
        expect(loader.loaded_paths).not_to include({baz: 'fake_dir/baz'})
      end
    end
  end
end
