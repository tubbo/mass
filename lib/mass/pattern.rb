module Mass
  # A single pattern written using the +Mass+ DSL. This is the
  # "collection"-style object which holds each +Note+ and plays
  # them in sequence, but has no control over their durations or
  # pitches.
  class Pattern
    attr_reader :name, :bars, :notes

    # @param [String] name
    # @param [Integer] bars
    # @param block
    def initialize(name: '', bars: 4, &block)
      @name = name
      @bars = bars
      @notes = []
      yield if block_given?
    end

    # Create a new pattern and immediately play it.
    #
    # @param [String] name
    # @param [Integer] bars
    # @param block
    def self.create(name: '', bars: 4, repeat: false, &block)
      pattern = new(name: name, bars: bars, &block)
      pattern.play! in_loop: repeat
      pattern
    end

    # Play the instantiated pattern once, or in a loop if opted
    # into it.
    #
    # @param [Boolean] in_loop - defaults to +false+.
    def play!(in_loop: false)
      _play_once unless in_loop
      loop { _play_once }
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
        midi: _midi
      )
    end

    def rest(value)
      note value
    end

    private

    def _midi
      @midi ||= UniMIDI::Output.gets
    end

    def _play_once
      notes.map(&:play)
    end
  end
end
