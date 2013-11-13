# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

$:.unshift(File.expand_path("../lib", __FILE__))

RSpec::Matchers.define :have_frames do |expected|
  match do |actual|
    actual   = actual.split("\e[H\e[2J\n").select { |f|
      (/\S/ === f)
    }.map(&:chomp)
    expected = Array(expected)
    actual == expected
  end
end

def create_dir(dir_path)
  mkdir_p dir_path unless File.exist?(dir_path)
  dir_path
end
