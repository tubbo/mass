require 'forwardable'

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
    def initialize(value: 1, pitch: nil, exp: :mp, midi: nil)
      @value = value
      @pitch = Pitch.find pitch
      @expression = exp
      @midi = midi
    end

    # The given note name.
    #
    # @return [String]
    def_delegator :pitch, :name, :id

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
      value / Mass.current_bpm
    end

    # Play the current note through the +UniMIDI+ output.
    def play
      midi.puts ON, to_midi, to_velocity if pitch.present?
      sleep duration
      midi.puts OFF, to_midi, to_velocity if pitch.present?
    end
  end
end
