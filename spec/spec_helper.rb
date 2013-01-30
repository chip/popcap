require 'reek/spec'
require 'simplecov'

SimpleCov.start

RSpec.configure do
  include Reek::Spec
  treat_symbols_as_metadata_keys_with_true_values = true
  run_all_when_everything_filtered = true
  order = 'random'
end
