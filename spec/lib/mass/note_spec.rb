require 'spec_helper'
require 'mass/note'

module Mass
  RSpec.describe Note, type: :unit do
    let :midi do
      double 'UniMIDI::Output'
    end

    before do
      allow(midi).to receive(:puts).with(
        Note::ON, subject.to_midi, subject.to_velocity
      ).and_return(true)
      allow(midi).to receive(:puts).with(
        Note::OFF, subject.to_midi, subject.to_velocity
      ).and_return(true)
    end

    subject do
      Note.new(
        value: 4,
        pitch: 'C3',
        exp: :f,
        midi: midi
      )
    end

    it 'has a value' do
      expect(subject.value).to eq 4
    end

    it 'finds a pitch for the given note' do
      expect(subject.pitch).not_to be_nil
    end

    it 'will play at forte velocity' do
      expect(subject.expression).to eq :f
    end

    it 'finds velocity from given expression' do
      expect(subject.to_velocity).to eq Note::VELOCITIES[:f]
    end

    it 'calculates duration based on current bpm' do
      expect(subject.bpm).to eq 100
      expect(subject.value).to eq 4
      expect(subject.duration).to eq 0.25
    end

    it 'plays note through midi adapter' do
      expect(subject.play).to eq true
    end
  end
end
