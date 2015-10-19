require 'forwardable'
require 'mass/pitch'
require 'mass/component'

module Mass
  # Represents a single note in the Pattern, and typically created by
  # the +note+ method, notes are typically created first and then
  # executed in sequence by the pattern once they are all defined. That
  # said, notes can also be created programatically with the +create+
  # method defined by every other component.
  #
  # @example
  #
  #   Note.create value: 4, pitch: 'C4', expression: :ff
  #
  class Note < Component
    extend Forwardable

    # Dictionary of velocity values from a given +expression+.
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
    ON = 0x90

    # Hex value for sending to +UniMIDI+ that signals when
    # this note should cease playing.
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
    #
    # @return [Fixnum]
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
    #
    # @return [Boolean] +true+ if the note played successfully.
    def play
      puts "Playing note #{pitch} at :#{expression} on '#{@device}'"
      midi.puts ON, to_midi, to_velocity unless pitch.nil?
      sleep duration
      midi.puts OFF, to_midi, to_velocity unless pitch.nil?
      true
    end

    private

    # "Values" per minute, a value defined by dividing the note value
    # (which must be greater than 0) by the bpm of the pattern.
    #
    # @private
    # @return [Integer]
    def vpm
      bpm / value
    end
  end
end
