require 'spec_helper'
require 'pop_cap/global_namespace'
require 'support/popcap_spec_helper'

module PopCap
  describe GlobalNamespace do
    let(:global) { GlobalNamespace }

    describe '.class_names' do
      it 'includes all Ruby class names in ObjectSpace' do
        expect(global.class_names).to eq PopCapSpecHelper.object_names(Class)
      end
    end

    describe '.classes' do
      it 'includes all Ruby class names in ObjectSpace' do
        expect(global.classes).to eq PopCapSpecHelper.classes
      end
    end

    describe '.all' do
      it 'includes all Ruby classes & modules in ObjectSpace' do
        unique = (global.classes + global.modules).uniq
        expect(global.all).to eq(unique)
      end
    end

    describe '.all_names' do
      it 'includes all Ruby class & names in ObjectSpace' do
        unique_names = (global.class_names + global.module_names).uniq
        expect(global.all_names).to eq(unique_names)
      end
    end

    describe '.modules' do
      it 'includes all Ruby modules in ObjectSpace' do
        expect(global.modules).to eq PopCapSpecHelper.modules
      end
    end

    describe '.module_names' do
      it 'includes all Ruby module names in ObjectSpace' do
        expect(global.module_names).to eq PopCapSpecHelper.object_names(Module)
      end
    end

    describe '#in_namespace?' do
      it 'returns true if Class is in namespace' do
        global = GlobalNamespace.new('Array')
        expect(global.in_namespace?).to be_true
      end

      it 'returns true if Module is in namespace' do
        global = GlobalNamespace.new('Enumerable')
        expect(global.in_namespace?).to be_true
      end

      it 'returns false if object is not in namespace' do
        global = GlobalNamespace.new('Foo')
        expect(global.in_namespace?).to be_false
      end
    end

    describe '.difference' do
      context 'shows the difference between to states of the ObjectSpace' do
        it 'returns the names' do
          before = GlobalNamespace.all_names
          require 'bigdecimal'
          after = GlobalNamespace.all_names

          expect(GlobalNamespace.difference({before: before, after: after})).
            to include('BigDecimal', 'BigMath')
        end
      end
    end
  end
end
