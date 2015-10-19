require 'bundler/setup'
require 'mass'

Mass.sequence name: 'Your Love', bpm: 125, bars: 32 do
  pattern name: 'Arpeggio', repeat: true, device: 'KORG INC. MS-20M Kit' do
    note 8, pitch: 'G4'
    note 8, pitch: 'E4'
    note 8, pitch: 'C4'
  end

  pattern name: 'Bass Line', repeat: true, device: 'Dave Smith Instruments Tempest' do
    note 8, pitch: 'G4'
    note 4, pitch: 'E4'
    note 8, pitch: 'C4'
    note 4, pitch: 'C4'
    note 4, pitch: 'C4'
  end
end
