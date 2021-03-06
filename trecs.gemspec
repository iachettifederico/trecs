lib = File.expand_path('../lib', __FILE__)
bin = File.expand_path('../bin', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$LOAD_PATH.unshift(bin) unless $LOAD_PATH.include?(bin)
require 'trecs/version'

Gem::Specification.new do |spec|
  spec.name          = "trecs"
  spec.version       = TRecs::VERSION
  spec.authors       = ["Federico Iachetti"]
  spec.email         = ["iachetti.federico@gmail.com"]
  spec.summary       = %q{TRecs: Text Recordings.}
  spec.description   = %q{Record text screencasts.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "lib/trecs", "bin"]

  # Dependencies
  spec.add_dependency "trollop"
  spec.add_dependency "minitar"

  # Development dependencies
  spec.add_development_dependency "bundler",     "~> 1.6"
  spec.add_development_dependency "rake",        "~> 11.1.2"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-given"

end
