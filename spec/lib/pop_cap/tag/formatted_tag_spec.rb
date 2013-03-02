require 'spec_helper'
require 'pop_cap/tag/formatted_tag'

module PopCap
  describe FormattedTag do
    class FakeFormatter
      def self.format(value)
        value.to_i
      end
    end

    describe '#format' do
      it 'formats a value with the formatter' do
        tag = FormattedTag.new(FakeFormatter, '123')
        expect(tag.format).to eq 123
      end
    end

    describe '.format' do
      it 'wraps #new & #format' do
        instance = double('FormattedTagInstance')
        FormattedTag.should_receive(:new).with(FakeFormatter, '123').
          and_return(instance)
        instance.should_receive(:format)
        FormattedTag.format(FakeFormatter, '123')
      end
    end
  end
end
