require 'unimidi'
require 'mass/component'
require 'mass/note'

module Mass
  # A single pattern written using the +Mass+ DSL. This is the
  # "collection"-style object which holds each +Note+ and plays
  # them in sequence, but has no control over their durations or
  # pitches.
  #
  # @example
  #
  #   Pattern.create bars: 1 do
  #     note 1, pitch: 'C1'
  #   end
  #
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

    # The sequence that this +Pattern+ runs in the context of.
    #
    # @attr_reader [Mass::Sequence]
    attr_reader :sequence

    # @param args - A hash of keyword arguments
    def initialize(**args)
      super
      @_notes = []
    end

    # Play all notes in the pattern in order, opening and closing the
    # MIDI connection around the actual playback.
    #
    # @return [Boolean] +true+ when the pattern has completed.
    def play
      puts "Playing pattern #{name} at #{bpm}"
      open! && play! && close!
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
    # @return [Mass::Note]
    def note(value, pitch: nil, expression: nil)
      @_notes << Note.define(
        value: value,
        pitch: pitch,
        exp: expression,
        midi: midi,
        bpm: bpm,
        device: device
      )
    end

    # Shorthand for describing a note which has a rhythmic duration but
    # no pitch value.
    #
    # @return [Mass::Note]
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

    # Open a connection to the configured UniMIDI output device so we
    # may begin sending MIDI note data in this pattern.
    #
    # @private
    # @return [Boolean] +true+ if the device has been opened.
    def open!
      puts "Opening MIDI connection to '#{device}'"
      @midi = UniMIDI::Output.gets if midi.nil?
      midi.open
    end

    # Close the MIDI connection to the configured UniMIDI output device.
    #
    # @private
    # @return [Boolean] +true+ if the device has closed.
    def close!
      puts "Closing MIDI connection to '#{device}'"
      midi.close
    end

    # Play all notes in sequence, and continue playing if the sequence
    # has not stopped.
    #
    # @private
    # @return [Boolean] +true+ when playback has stopped.
    def play!
      _notes.all?(&:play)
      play! if sequence.playing?
    end
  end
end
