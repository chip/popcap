require 'spec_helper'

describe 'Code Quality' do
  it 'has no code smells' do
    expect(Dir['lib/**/*.rb']).not_to reek
  end
end
