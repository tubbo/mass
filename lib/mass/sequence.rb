require 'mass/node'

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

    # @attr_reader [Array<Pattern>]
    attr_reader :_patterns

    # Play this sequence by playing all of its patterns simultaneously.
    def play
      puts "Playing sequence #{name} at #{bpm}"
      threads = _patterns.map do |pattern|
        Thread.new do
          pattern.map(&:play)
        end
      end
      threads.map(&:join)
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
      @_patterns << Pattern.define(**params.merge(bpm: _bpm), &block)
    end
  end
end
