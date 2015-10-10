require 'unimidi'

require 'mass/version'
require 'mass/pitch'
require 'mass/note'
require 'mass/pattern'
require 'mass/sequence'

# A massive synth library.
module Mass
  def self.sequence(*args)
    Sequence.define(*args)
  end
end
