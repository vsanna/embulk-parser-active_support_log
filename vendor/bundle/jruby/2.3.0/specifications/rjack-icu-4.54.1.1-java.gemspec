# -*- encoding: utf-8 -*-
# stub: rjack-icu 4.54.1.1 java lib

Gem::Specification.new do |s|
  s.name = "rjack-icu".freeze
  s.version = "4.54.1.1"
  s.platform = "java".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Kellum".freeze]
  s.date = "2015-02-05"
  s.email = ["dek-oss@gravitext.com".freeze]
  s.extra_rdoc_files = ["History.rdoc".freeze, "README.rdoc".freeze]
  s.files = ["History.rdoc".freeze, "README.rdoc".freeze]
  s.homepage = "http://rjack.gravitext.com/icu".freeze
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "2.6.4".freeze
  s.summary = "A gem packaging of ICU4J.".freeze

  s.installed_by_version = "2.6.4" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>.freeze, ["~> 4.7.4"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 4.0.1"])
      s.add_development_dependency(%q<rjack-tarpit>.freeze, ["~> 2.1"])
    else
      s.add_dependency(%q<minitest>.freeze, ["~> 4.7.4"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 4.0.1"])
      s.add_dependency(%q<rjack-tarpit>.freeze, ["~> 2.1"])
    end
  else
    s.add_dependency(%q<minitest>.freeze, ["~> 4.7.4"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 4.0.1"])
    s.add_dependency(%q<rjack-tarpit>.freeze, ["~> 2.1"])
  end
end
