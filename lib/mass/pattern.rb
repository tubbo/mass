require 'unimidi'
require 'mass/note'

module Mass
  # A single pattern written using the +Mass+ DSL. This is the
  # "collection"-style object which holds each +Note+ and plays
  # them in sequence, but has no control over their durations or
  # pitches.
  class Pattern
    attr_reader :name, :bars, :notes, :sequence

    # @param [String] name
    # @param [Integer] bars
    # @param block
    def initialize(name: '', bars: 4, sequence: nil, &block)
      @name = name
      @bars = bars
      @notes = []
      @sequence = sequence
      yield if block_given?
    end

    # Create a new pattern and immediately play it.
    #
    # @param [String] name
    # @param [Integer] bars
    # @param block
    def self.create(name: '', bars: 4, repeat: false, sequence: sequence, &block)
      pattern = new(name: name, bars: bars, sequence: sequence, &block)
      pattern.play in_loop: repeat if pattern.notes.any?
      pattern
    end

    # Play the instantiated pattern once, or in a loop if opted
    # into it.
    #
    # @param [Boolean] in_loop - defaults to +false+.
    def play(in_loop: false)
      return _play_once unless in_loop
      _play_in_loop
    end

    # Tests equivilance bases on name
    #
    # @return [Boolean] whether both patterns have the same name
    def ==(pattern)
      pattern.name == name
    end

    protected

    # Part of the DSL, the +note+ method instantiates a
    # new +Note+ object with the given parameters and
    # pushes it into the pattern's notes collection.
    #
    # @private
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
        midi: sequence._midi,
        bpm: sequence._bpm
      )
    end

    def rest(value)
      note value
    end

    private

    def _play_once
      notes.all?(&:play)
    end

    def _play_in_loop
      loop { _play_once }
    end
  end
end
