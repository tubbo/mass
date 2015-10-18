require 'unimidi'
require 'mass/note'

module Mass
  # A single pattern written using the +Mass+ DSL. This is the
  # "collection"-style object which holds each +Note+ and plays
  # them in sequence, but has no control over their durations or
  # pitches.
  class Pattern
    attr_reader :name, :bars, :notes, :device, :bpm

    # @param [String] name
    # @param [Integer] bars
    # @param block
    def initialize(name: '', bars: 4, device: '', repeat: false, bpm: 100)
      @name = name
      @bars = bars
      @notes = []
      @device = device
      @repeat = repeat
      @bpm = bpm
    end

    def self.define(**params, &block)
      pattern = new(**params)
      pattern.instance_eval(&block)
      pattern
    end

    # Play the instantiated pattern once, or in a loop if opted
    # into it.
    #
    # @param [Boolean] in_loop - defaults to +false+.
    def _play
      return _play_once unless looped?
      _play_in_loop
    end

    # Whether this pattern should play in a loop. Default is false.
    #
    # @return [Boolean]
    def looped?
      @repeat ||= false
    end

    # Tests equivilance bases on name
    #
    # @return [Boolean] whether both patterns have the same name
    def ==(other)
      other.name == name
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
      @notes << Note.new(
        value: value,
        pitch: pitch,
        exp: expression,
        midi: midi,
        bpm: bpm
      )
    end

    def rest(value)
      note value
    end

    private

    def _play_once
      notes.all?(&:play)
      midi.close
    end

    def _play_in_loop
      loop { _play_once }
    end

    def midi
      UniMIDI::Output.find_by_name(device).open
    end
  end
end
