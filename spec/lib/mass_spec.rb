require 'spec_helper'
require 'mass'

RSpec.describe Mass do
  let :midi do
    double 'UniMIDI::Output', puts: true
  end

  before do
    allow(UniMIDI::Output).to receive(:gets).and_return(midi)
  end

  it 'has a version number' do
    expect(Mass::VERSION).not_to be nil
  end

  it 'defines a sequence' do
    expect(Mass.sequence(:name)).to be_a(Mass::Sequence)
  end
end
