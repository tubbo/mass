require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

# Run RSpec code examples
RSpec::Core::RakeTask.new :spec

desc "Run RuboCop lint checks"
RuboCop::RakeTask.new :lint

desc "Run RuboCop lint checks and RSpec code examples"
task test: %i[spec lint]

# Run all tests, then build and install the gem on CI.
task default: %i[test install]
