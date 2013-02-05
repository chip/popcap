require 'spec_helper'

describe 'Code Quality' do
  it 'has no code smells' do
    pending 'Enable to test for code smells.'
    expect(Dir['lib/**/*.rb']).not_to reek
  end
end
