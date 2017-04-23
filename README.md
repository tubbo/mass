# Mass

[![Build Status](https://travis-ci.org/tubbo/mass.svg?branch=master)](https://travis-ci.org/tubbo/mass)
[![Code Climate](https://codeclimate.com/github/tubbo/mass/badges/gpa.svg)](https://codeclimate.com/github/tubbo/mass)
[![Test Coverage](https://codeclimate.com/github/tubbo/mass/badges/coverage.svg)](https://codeclimate.com/github/tubbo/mass/coverage)
[![Inline docs](http://inch-ci.org/github/tubbo/mass.svg?branch=master)](http://inch-ci.org/github/tubbo/mass)

Mass is a Ruby framework for building MIDI synthesizer controls.

## Installation

On Linux, the **libasound** and **libasound-dev** are required for use.

Add this line to your application's Gemfile:

```ruby
gem 'mass'
```

And then execute:

```bash
$ bundle
```

Or install it yourself:

```bash
$ gem install mass
```

## Usage

To create a new pattern, use the DSL methods that Mass gives you upon
mixing it into whatever namespace you're dealing with.

```ruby
require 'mass'

include Mass

bpm 128
pattern bars: 4 do
  note 4, pitch: 'C2'
  note 4, pitch: 'C3'
  note 4, pitch: 'C4'
  note 4, pitch: 'C3'
end
```

You can also use this syntax to also name the sequence and keep it out
of the main namespace:

```ruby
MS20 = 'KORG INC. MS-20M Kit'
TEMPEST = 'Dave Smith Instruments Tempest'

Mass.sequence name: 'Your Love', bpm: 125, bars: 32 do
  pattern name: 'Arpeggio', repeat: true, device: MS20 do
    note 8, pitch: 'G4'
    note 8, pitch: 'E4'
    note 8, pitch: 'C4'
  end

  pattern name: 'Bass Line', repeat: true, device: TEMPEST do
    note 8, pitch: 'G4'
    note 4, pitch: 'E4'
    note 8, pitch: 'C4'
    note 4, pitch: 'C4'
    note 4, pitch: 'C4'
  end
end
```

This is useful for more complex patterns with names. Read the
[RDoc documentation][rdoc] for more information on each component and what
each DSL method does.

## Development

Mass was created by [Tom Scott][tubbo] and is published under
the [MIT License][mit]. All contributions are welcome as long
as they are submitted via pull request, include tests that
describe your change and prove what you did works, and do not
break the CI build.

To get started with contributing, clone down this repo and run the
following command within its root directory:

```bash
$ bin/setup
```

If you need to install this gem onto your local machine, run:

```bash
$ bin/rake install
```

To release a new version, update the version number in
**lib/mass/version.rb**, then run the following command to create a Git
tag for the release, push all commits & tags to the repo, and upload the
newly built `.gem` file to [RubyGems][gem]:

```bash
$ bin/rake release
```

[tubbo]: https://github.com/tubbo
[rdoc]: http://www.rubydoc.info/github/tubbo/mass/master/frames
[gem]: https://rubygems.org
[mit]: https://github.com/tubbo/mass/blob/master/LICENSE.txt
