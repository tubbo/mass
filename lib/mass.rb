require 'unimidi'

require 'mass/version'
require 'mass/pitch'
require 'mass/note'
require 'mass/pattern'
require 'mass/sequence'

# A ruby framework for building MIDI synthesizer controls.
#
# @author Tom Scott <tubbo@psychedeli.ca>
# @example
#
#   require 'mass'
#
#   Mass.sequence do
#     pattern bars: 4 do
#       note 4, pitch: 'C2'
#       note 4, pitch: 'C3'
#       note 4, pitch: 'C4'
#       note 4, pitch: 'C3'
#     end
#   end
#
#
module Mass
  # Create a new sequence in the Mass DSL and immediately play it.
  #
  # @return [Mass::Sequence]
  def self.sequence(**kws, &block)
    Sequence.play(**kws, &block)
  end
end
