require 'spec_helper'
require 'pop_cap/commander'

module PopCap
  describe Commander do
    let(:commander) { Commander.new(%W{ls},%W{-l},%W{/tmp}) }

    context "#new" do
      it 'raises an error if no arguments' do
        expect{Commander.new}.to raise_error(ArgumentError)
      end

      it 'sets @executed to empty' do
        expect(commander.instance_variable_get('@executed')).to be_empty
      end

      it 'escapes @command' do
        expect(commander.instance_variable_get('@command')).
          to eq([['ls'],['-l'],['/tmp']])
      end
    end

    context '#execute' do
      it 'executes a shell command' do
        Open3.should_receive(:capture3).with(['ls'],['-l'],['/tmp'])
        commander.execute
      end

      it 'returns itself' do
        Open3.should_receive(:capture3).with('blah')
        command = Commander.new('blah')
        expect(command.execute).to be_a(Commander)
      end
    end

    it 'returns stdout' do
      Open3.should_receive(:capture3).with('blah') { ['foo',nil,nil] }
      command = Commander.new('blah').execute
      expect(command.stdout).to eq('foo')
    end

    it 'returns stderr' do
      Open3.should_receive(:capture3).with('blah') { [nil,'bar',nil] }
      command = Commander.new('blah').execute
      expect(command.stderr).to eq('bar')
    end

    context '#status' do
      it 'is true if it succeeds' do
        succeeded = double('status', success?: true)
        Open3.should_receive(:capture3).with('blah') { [nil,nil,succeeded] }
        command = Commander.new('blah').execute
        expect(command.status.success?).to be_true
      end

      it 'is false if it fails' do
        failed = double('status', success?: false)
        Open3.should_receive(:capture3).with('blah') { [nil,nil,failed] }
        command = Commander.new('blah').execute
        expect(command.status.success?).to be_false
      end
    end
  end
end
