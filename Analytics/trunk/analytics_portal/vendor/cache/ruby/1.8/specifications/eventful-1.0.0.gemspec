# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{eventful}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Coglan"]
  s.date = %q{2009-06-17}
  s.description = %q{}
  s.email = ["jcoglan@googlemail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/eventful.rb", "test/test_eventful.rb"]
  s.homepage = %q{http://github.com/jcoglan/eventful}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{eventful}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{}
  s.test_files = ["test/test_eventful.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<methodphitamine>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.0.0"])
    else
      s.add_dependency(%q<methodphitamine>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.0.0"])
    end
  else
    s.add_dependency(%q<methodphitamine>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.0.0"])
  end
end
