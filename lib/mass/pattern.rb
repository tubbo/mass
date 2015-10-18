require 'unimidi'
require 'mass/component'
require 'mass/note'

module Mass
  # A single pattern written using the +Mass+ DSL. This is the
  # "collection"-style object which holds each +Note+ and plays
  # them in sequence, but has no control over their durations or
  # pitches.
  class Pattern < Component
    # Configured name of this pattern.
    #
    # @attr_reader [String]
    attr_reader :name

    # Amount of bars to run this pattern for.
    #
    # @attr_reader [Integer]
    attr_reader :bars

    # Device used to play back this pattern.
    #
    # @attr_reader [String]
    attr_reader :device

    # BPM passed down by the sequence.
    #
    # @attr_reader [Integer]
    attr_reader :bpm

    # Notes collection.
    #
    # @attr_reader [Array<Note>]
    attr_reader :_notes

    def initialize(**args)
      super
      @_notes = []
    end

    # Play all notes in the pattern in order.
    #
    # @return [Boolean] +true+ when the pattern has completed.
    def play
      puts "Playing pattern #{name} at #{bpm}"
      puts "Opening MIDI connection to '#{device}'"
      midi.open

      if looped?
        puts "...in a loop"

        loop do
          trap('INT') { break }
          _notes.each(&:play)
        end
      else
        _notes.each(&:play)
      end

      puts "Closing MIDI connection to '#{device}'"
      midi.close
    end

    # Whether this pattern should play in a loop. Default is false.
    #
    # @return [Boolean]
    def looped?
      @repeat ||= false
    end

    # Part of the DSL, the +note+ method instantiates a
    # new +Note+ object with the given parameters and
    # pushes it into the pattern's notes collection.
    #
    # @param [Integer] value - Value of each note
    # @param [String] pitch - String representation
    #                         of MIDI note, e.g. 'c4'
    # @param [Symbol] expression - Symbolic representation
    #                              of MIDI velocity, e.g. ':ff'
    def note(value, pitch: nil, expression: nil)
      @_notes << Note.define(
        value: value,
        pitch: pitch,
        exp: expression,
        midi: midi,
        bpm: bpm
      )
    end

    # Shorthand for describing a note which has a rhythmic duration but
    # no pitch value.
    def rest(value)
      note value
    end

    private

    # MIDI device based on name.
    #
    # @private
    # @return [UniMIDI::Output]
    def midi
      @midi ||= UniMIDI::Output.find_by_name(device)
    end
  end
end
