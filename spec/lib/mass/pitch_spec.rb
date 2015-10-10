require 'spec_helper'
require 'mass/pitch'

module Mass
  RSpec.describe Pitch, type: :unit do
    subject { Pitch.new id: 'C4' }

    it 'finds the name of the note' do
      expect(subject.name).to eq 'C'
    end

    it 'finds the numeric octave of the note' do
      expect(subject.octave).to eq 4
    end

    it 'finds the base midi value of the note from its name' do
      expect(subject.value).to eq Pitch::VALUES['C']
    end

    it 'validates all parameters' do
      expect(subject).to be_valid
    end

    it 'computes the midi value of this pitch' do
      midi_pitch = subject.value + (12 * subject.octave)
      expect(subject.to_i).to eq midi_pitch
    end

    it 'can be found by id' do
      expect(Pitch.find('C4')).to eq subject
    end
  end
end
