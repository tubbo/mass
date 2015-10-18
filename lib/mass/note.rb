require 'forwardable'
require 'mass/pitch'
require 'mass/node'

module Mass
  # Represents a single note in the pattern.
  class Note < Node
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

    # MIDI output object passed in by the sequence.
    #
    # @attr_reader [UniMIDI::Output]
    attr_reader :midi

    # BPM passed in from the sequence.
    #
    # @attr_reader [Integer]
    attr_reader :bpm

    # This note as expressed in a MIDI pitch value.
    #
    # @return [Integer]
    def_delegator :pitch, :to_i, :to_midi

    # Pitch object used for figuring out the MIDI pitch
    # value.
    #
    # @attr_reader [Mass::Pitch]
    def pitch
      @_pitch ||= Pitch.find(@pitch)
    end

    # Rhythmic duration value for this note. Defaults to 1
    #
    # @return [Integer]
    def value
      @value ||= 1
    end

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
    # The default expression value is +:mp+.
    #
    # @attr_reader [Symbol | Integer]
    def expression
      @expression ||= :mp
    end

    # Play the current note through the +UniMIDI+ output.
    def play
      puts "Playing note #{pitch} at '#{expression}'"
      midi.puts ON, to_midi, to_velocity unless pitch.nil?
      sleep duration
      midi.puts OFF, to_midi, to_velocity unless pitch.nil?
    end

    private

    # @private
    # @return [Integer]
    def vpm
      bpm / value
    end
  end
end
