require 'spec_helper'
require 'mass/sequence'

module Mass
  RSpec.describe Sequence, type: :unit do
    subject do
      Sequence.new 'name'
    end

    let :midi do
      double 'UniMIDI::Output', puts: true
    end

    before do
      allow(UniMIDI::Output).to receive(:gets).and_return(midi)
    end

    it 'has a name' do
      expect(subject.name).to eq 'name'
    end

    it 'has a default bpm' do
      expect(subject._bpm).to eq 100
    end

    it 'can set the new bpm' do
      expect(subject.bpm 128).to eq 128
      expect(subject._bpm).to eq 128
      expect(subject.bpm 100).to eq 100
    end

    it 'creates new patterns' do
      expect(subject.pattern(name: 'test', bars: 4)).to \
        be_a(Pattern)
    end

    it 'has a midi driver' do
      expect(subject._midi).not_to be_nil
    end
  end
end
