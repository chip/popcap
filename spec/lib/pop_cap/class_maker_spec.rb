require 'spec_helper'
require 'pop_cap/class_maker'

module PopCap
  describe ClassMaker do
    context '#camelize' do
      it 'converts to CamelCase' do
        maker = ClassMaker.new('one_two')
        expect(maker.camelize).to eq('OneTwo')
      end

      it 'handles symbols' do
        maker = ClassMaker.new(:one_two_three)
        expect(maker.camelize).to eq('OneTwoThree')
      end
    end

    context '#namespace' do
      it 'accounts for namespacing with a forward slash' do
        maker = ClassMaker.new('one/two/three_four')
        expect(maker.namespace).to eq('One::Two::ThreeFour')
      end

      it 'accounts for mixed case in namespacing' do
        maker = ClassMaker.new('One/Two/Three_Four')
        expect(maker.namespace).to eq('One::Two::ThreeFour')
      end
    end

    context '#constantize' do
      it 'converts to a constant' do
        maker = ClassMaker.new('array')
        expect(maker.constantize).to eq(Array)
      end

      it 'handles module namespacing' do
        maker = ClassMaker.new('file/stat')
        expect(maker.constantize).to eq(File::Stat)
      end
    end
  end
end
