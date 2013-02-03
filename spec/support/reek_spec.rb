require 'spec_helper'

describe 'Code Quality' do
  xit 'has no code smells' do
    expect(Dir['lib/**/*.rb']).not_to reek
  end
end
