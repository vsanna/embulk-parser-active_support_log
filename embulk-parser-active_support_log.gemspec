
Gem::Specification.new do |spec|
  spec.name          = "embulk-parser-active_support_log"
  spec.version       = "0.1.0"
  spec.authors       = ["Ryu Ishikawa"]
  spec.summary       = "ActiveSupport::Logger parser plugin for Embulk"
  spec.description   = "Parses Lesson files read by other file input plugins."
  spec.email         = ["ryu.ishikawa@howtelevision.jp"]
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = "https://github.com/ryu.ishikawa/embulk-parser-lesson"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'embulk', ['>= 0.8.12']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
end
