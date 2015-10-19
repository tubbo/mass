require 'mass/component'

module Mass
  # A sequence of patterns that is played in order immediately
  # as it is defined.
  class Sequence < Component
    # Name of this sequence
    #
    # @attr_reader [String]
    attr_reader :name

    # Beats per minute speed of the sequence. Defaults to 100.
    #
    # @attr_reader [Integer]
    attr_reader :bpm

    # Number of bars this sequence plays for.
    #
    # @attr_reader [Integer]
    attr_reader :bars

    # Collection of patterns defined within this sequence.
    #
    # @attr_reader [Array<Pattern>]
    attr_reader :_patterns

    # @param args - Keyword arguments to set up data.
    def initialize(**args)
      super
      @_patterns = []
    end

    # Play this sequence by playing all of its patterns simultaneously.
    #
    # @return [Boolean] +true+ when all threads have joined together.
    def play
      puts "Playing sequence #{name} at #{bpm}"
      threads = _patterns.map do |pattern|
        Thread.new do
          pattern.play
        end
      end
      threads.all?(&:join)
    end

    # Create a pattern. See the docs on +Mass::Pattern+ for more
    # information about its requirements.
    #
    # @param params - Keyword arguments of params.
    # @param [Proc] block
    # @example
    #   pattern name: 'verse', bars: 1 do
    #     note 8, pitch: 'C4'
    #     note 8, pitch: 'C3'
    #     note 8, pitch: 'A3'
    #     note 8, pitch: 'B4'
    #     note 8, pitch: 'C4'
    #     note 8, pitch: 'Gb2'
    #     note 8, pitch: 'C4'
    #     rest 8
    #   end
    #
    def pattern(**params, &block)
      options = { bpm: bpm, bars: bars, sequence: self }.merge(params)
      @_patterns << Pattern.define(**options, &block)
    end
  end
end
