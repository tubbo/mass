require 'unimidi'

require 'mass/version'
require 'mass/pitch'
require 'mass/note'
require 'mass/pattern'

# A massive synth library.
module Mass
  class << self
    # The current BPM of this track. Defaults to +100+.
    #
    # @return [Integer]
    def current_bpm
      @current_bpm ||= 100
    end

    # Change BPM of the track.
    #
    # @example
    #   require 'mass'
    #   include Mass
    #
    #   bpm 128
    #
    def bpm(new_bpm)
      @current_bpm = new_bpm
    end

    # Create a pattern in Mass.
    #
    # @example
    #   require 'mass'
    #   include Mass
    #
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
      Pattern.create(**params, &block)
    end
  end
end
