require 'spec_helper'
require 'mayfly/helper'

module Mayfly
  describe Helper do
    context '#camelize' do
      it 'converts to CamelCase' do
        helper = Helper.new('one_two')
        expect(helper.camelize).to eq('OneTwo')
      end

      it 'handles symbols' do
        helper = Helper.new(:one_two_three)
        expect(helper.camelize).to eq('OneTwoThree')
      end
    end

    context '#namespace' do
      it 'accounts for namespacing with a forward slash' do
        helper = Helper.new('one/two/three_four')
        expect(helper.namespace).to eq('One::Two::ThreeFour')
      end

      it 'accounts for mixed case in namespacing' do
        helper = Helper.new('One/Two/Three_Four')
        expect(helper.namespace).to eq('One::Two::ThreeFour')
      end
    end

    context '#constantize' do
      it 'converts to a constant' do
        helper = Helper.new('array')
        expect(helper.constantize).to eq(Array)
      end

      it 'handles module namespacing' do
        helper = Helper.new('file/stat')
        expect(helper.constantize).to eq(File::Stat)
      end
    end
  end
end
