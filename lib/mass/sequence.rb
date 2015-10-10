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

    # MIDI driver used to power all notes in the sequence.
    #
    # @attr_reader [UniMIDI::Output]
    attr_reader :_midi

    # @param [String] name
    # @option [Integer] bpm - defaults to 100
    def initialize(name, bpm: 100)
      @name = name
      @_bpm = bpm
      @_midi ||= UniMIDI::Output.gets
      yield if block_given?
    end

    # Define a new sequence into the global namespace
    #
    # @param [String] name
    # @options [KeywordArguments] params
    # @param [Proc] block
    # @return [Mass::Sequence]
    def self.define(name, **params, &block)
      new name, **params, &block
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
      Pattern.create(**params.merge(sequence: self), &block)
    end
  end
end
