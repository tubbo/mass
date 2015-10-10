# Mass

[![Build Status](https://travis-ci.org/tubbo/mass.svg?branch=master)](https://travis-ci.org/tubbo/mass)

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
  note 4, pitch: 'c2'
  note 4, pitch: 'c3'
  note 4, pitch: 'c4'
  note 4, pitch: 'c3'
end
```

Read the [RDoc documentation][rdoc] for more information on
each component and what each DSL method does.

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
