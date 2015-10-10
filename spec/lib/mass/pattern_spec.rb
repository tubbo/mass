require 'spec_helper'
require 'mass/pattern'

module Mass
  RSpec.describe Pattern, type: :unit do
    let :midi do
      double 'UniMIDI::Output', puts: true
    end

    before do
      allow(UniMIDI::Output).to receive(:gets).and_return(midi)
      allow(midi).to receive(:puts).and_return true
    end

    let :seq do
      double 'Sequence', _midi: midi, _bpm: 128
    end

    subject do
      Pattern.new name: 'pattern', sequence: seq
    end

    it 'has a name' do
      expect(subject.name).to eq 'pattern'
    end

    it 'has a length of bars' do
      expect(subject.bars).to eq 4
    end

    it 'contains a collection of notes' do
      expect(subject.notes).to be_a(Array)
    end

    it 'adds notes to the collection' do
      expect(subject.send :note, 4, pitch: 'C1').to eq subject.notes
    end

    it 'plays note collection in sequence' do
      expect(subject.play).to be true
    end

    it 'plays note collection in a loop' do
      allow(subject).to receive(:_play_in_loop).and_return true
      expect(subject.play in_loop: true).to be true
    end

    it 'can be created' do
      expect(Pattern.create(name: 'pattern')).to eq subject
    end
  end
end
