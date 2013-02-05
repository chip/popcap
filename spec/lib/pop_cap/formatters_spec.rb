require 'spec_helper'
require 'pop_cap/formatters'

module PopCap
  describe Formatters do
    class FakeKlass
      include Formatters
    end

    let(:formatter_files) { Dir['lib/pop_cap/formatters/*.rb'] }
    let(:faked) { FakeKlass.new }
    subject { faked }

    it 'requires all formatters in "formatter/"' do
      loaded_files = $LOADED_FEATURES
      formatter_files.each do |path|
        expect(loaded_files).to include(File.realpath(path))
      end
    end

    context "#included_formatters" do
      it 'builds a hash of included formatters' do
        expect(::INCLUDED_FORMATTERS).to be_a Hash
      end

      it 'has formatter names as keys' do
        formatter_files.each do |file|
          formatter_key = File.basename(file, '.rb').to_sym
          expect(::INCLUDED_FORMATTERS.keys).to include(formatter_key)
        end
      end

      it 'has the formatter path as the value' do
        formatter_files.each do |file|
          value = file.sub(%r(^lib\/),'').sub(%r(\.rb$),'')
          expect(::INCLUDED_FORMATTERS.values).to include(value)
        end
      end
    end
  end
end
