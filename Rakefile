require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

# Remove the original :release task, we are redefining it below.
Rake::Task['release'].clear

# Run RSpec code examples
RSpec::Core::RakeTask.new :test

desc 'Run RuboCop lint checks'
RuboCop::RakeTask.new :lint

desc 'Run RuboCop lint checks and RSpec code examples'
task test: %i(lint spec)

desc 'Bump the version, tag a commit and deploy to RubyGems with Travis CI'
task release: %w(build release:guard_clean release:source_control_push) do
  Bundler.ui.confirm(
    'Please wait for Travis CI to push the working build to RubyGems.'
  )
end

YARD::Rake::YardocTask.new :doc

# Run all tests, then build and install the gem on CI.
task default: %i(test install)
