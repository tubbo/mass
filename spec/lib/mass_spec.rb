require 'spec_helper'
require 'mass'

RSpec.describe Mass do
  it 'has a version number' do
    expect(Mass::VERSION).not_to be nil
  end

  it 'has a bpm' do
    expect(Mass.current_bpm).to eq(100)
  end

  it 'can set the new bpm' do
    expect(Mass.bpm 128).to eq 128
    expect(Mass.current_bpm).to eq 128
    expect(Mass.bpm 100).to eq 100
  end

  it 'can create a pattern with the current bpm' do
    expect(Mass).to respond_to(:pattern)
  end
end
