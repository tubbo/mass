require 'bundler/setup'
require 'mass'

include Mass::DSL

sequence :house, bpm: 125 do
  pattern repeat: true, device: 'KORG INC. MS-20M Kit' do
    note 8, pitch: 'G4'
    note 8, pitch: 'E4'
    note 8, pitch: 'C4'
  end
end
