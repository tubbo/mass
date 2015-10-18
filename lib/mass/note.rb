require 'forwardable'
require 'mass/pitch'

module Mass
  # Represents a single note in the pattern.
  class Note
    extend Forwardable

    # Dictionary of velocity values from a given +expression+.
    #
    # @type [Hash<Symbol>]
    VELOCITIES = {
      ff: 127,
      mf: 117,
      f: 107,
      mp: 97,
      p: 85,
      pp: 75
    }

    # Duration value of the note.
    #
    # @attr_reader [Integer]
    attr_reader :duration

    # Expression value of the note, e.g. ':ff'. This can
    # optionally be given as an Integer for maximum velocity
    # control and is simply output as the velocity.
    #
    # The following expression values are supported:
    #
    # - :ff
    # - :mf
    # - :f
    # - :mp
    # - :p
    # - :pp
    #
    # @attr_reader [Symbol | Integer]
    attr_reader :expression

    # MIDI output object.
    #
    # @attr_reader [UniMIDI::Output]
    attr_reader :midi

    # Pitch object used for figuring out the MIDI pitch
    # value.
    #
    # @attr_reader [Mass::Pitch]
    attr_reader :pitch

    # Rhythmic duration value for this note.
    #
    # @attr_reader [Integer]
    attr_reader :value

    # BPM passed in from the sequence.
    #
    # @attr_reader [Integer]
    attr_reader :bpm

    # Hex value for sending to +UniMIDI+ that signals when
    # this note should begin playing.
    #
    # @type [Fixnum]
    ON = 0x90

    # Hex value for sending to +UniMIDI+ that signals when
    # this note should cease playing.
    #
    # @type [Fixnum]
    OFF = 0x80

    # @param [Integer] value
    # @param [String] pitch
    # @param [Symbol | Integer] exp - Can be expressed as either
    # @param [UniMIDI::Output] midi
    def initialize(value: 1, pitch: nil, exp: :mp, midi: nil, bpm: 100)
      @value = value
      @name = pitch
      @pitch = Pitch.find pitch
      @expression = exp || :mp
      @midi = midi
      @bpm = bpm
    end

    # This note as expressed in a MIDI pitch value.
    #
    # @return [Integer]
    def_delegator :pitch, :to_i, :to_midi

    # This note as expressed in a MIDI velocity value.
    #
    # @return [Integer]
    def to_velocity
      VELOCITIES[expression] || expression
    end

    # The given duration value divided by the BPM of
    # the current song.
    def duration
      vpm * 0.01
    end

    # Play the current note through the +UniMIDI+ output.
    def play
      puts "note: #{to_midi} velocity: #{to_velocity} (#{expression})"
      midi.puts ON, to_midi, to_velocity unless pitch.nil?
      sleep duration
      midi.puts OFF, to_midi, to_velocity unless pitch.nil?
    end

    private

    def vpm
      bpm / value
    end
  end
end
