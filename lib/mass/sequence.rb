module Mass
  # A sequence of patterns that is played in order immediately
  # as it is defined.
  class Sequence
    # Name of this sequence
    #
    # @attr_reader [String]
    attr_reader :name

    # Beats per minute speed of the sequence
    #
    # @attr_reader [Integer]
    attr_reader :_bpm

    attr_reader :patterns

    # @param [String] name
    # @option [Integer] bpm - defaults to 100
    def initialize(name, bpm: 100)
      @name = name
      @patterns = []
      @_bpm = bpm
    end

    def self.define(name, **params, &block)
      sequence = new(name, **params)
      sequence.instance_eval(&block)
      puts "BPM: #{sequence._bpm}"
      sequence.patterns.map(&:_play)
      sequence
    end

    # Change BPM.
    #
    # @param [Integer] new_bpm
    # @example
    #   bpm 128
    #
    def bpm(new_bpm)
      @_bpm = new_bpm
    end

    # Create a pattern. See the docs on +Mass::Pattern+ for more
    # information about its requirements.
    #
    # @options [KeywordArguments] params
    # @options [Proc] block
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
      @patterns << Pattern.define(**params.merge(bpm: _bpm), &block)
    end
  end
end
