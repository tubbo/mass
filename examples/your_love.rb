require 'bundler/setup'
require 'mass'

include Mass::DSL

sequence name: 'Your Love', bpm: 125 do
  pattern name: 'Arpeggio', device: 'KORG INC. MS-20M Kit' do
    note 8, pitch: 'G4'
    note 8, pitch: 'E4'
    note 8, pitch: 'C4'
  end
end
