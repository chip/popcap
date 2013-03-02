require 'spec_helper'
require 'pop_cap/class_support'

module PopCap
  describe ClassSupport do
    context '#camelize' do
      it 'converts to CamelCase' do
        maker = ClassSupport.new('one_two')
        expect(maker.camelize).to eq('OneTwo')
      end

      it 'handles symbols' do
        maker = ClassSupport.new(:one_two_three)
        expect(maker.camelize).to eq('OneTwoThree')
      end
    end

    context '#symbolize' do
      it 'returns a symbol' do
        maker = ClassSupport.new('One')
        expect(maker.symbolize).to eq(:one)
      end

      it 'handles CamelCase' do
        maker = ClassSupport.new('OneTwo')
        expect(maker.symbolize).to eq(:one_two)
      end

      it 'demodulizes the symbol' do
        maker = ClassSupport.new('One::Two::ThreeFour')
        expect(maker.symbolize).to eq(:three_four)
      end
    end

    context '#namespace' do
      it 'accounts for namespacing with a forward slash' do
        maker = ClassSupport.new('one/two/three_four')
        expect(maker.namespace).to eq('One::Two::ThreeFour')
      end

      it 'accounts for mixed case in namespacing' do
        maker = ClassSupport.new('One/Two/Three_Four')
        expect(maker.namespace).to eq('One::Two::ThreeFour')
      end
    end

    context '#constantize' do
      it 'converts to a constant' do
        maker = ClassSupport.new('array')
        expect(maker.constantize).to eq(Array)
      end

      it 'handles module namespacing' do
        maker = ClassSupport.new('file/stat')
        expect(maker.constantize).to eq(File::Stat)
      end
    end
  end
end
