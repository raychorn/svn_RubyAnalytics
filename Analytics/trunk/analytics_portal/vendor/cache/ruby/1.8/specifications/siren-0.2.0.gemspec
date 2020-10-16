# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{siren}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Coglan"]
  s.date = %q{2009-07-06}
  s.description = %q{}
  s.email = ["jcoglan@googlemail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.txt"]
  s.files = ["History.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/siren.rb", "lib/siren/json.tt", "lib/siren/json.rb", "lib/siren/json_query.tt", "lib/siren/json_query.rb", "lib/siren/json_query_nodes.rb", "lib/siren/node.rb", "lib/siren/parser.rb", "lib/siren/reference.rb", "lib/siren/walker.rb", "test/test_siren.rb", "test/fixtures/beatles.json", "test/fixtures/car.rb", "test/fixtures/names.json", "test/fixtures/people.json", "test/fixtures/person.rb", "test/fixtures/refs.json", "test/fixtures/store.json"]
  s.homepage = %q{http://github.com/jcoglan/siren}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{siren}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{}
  s.test_files = ["test/test_siren.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<treetop>, [">= 0"])
      s.add_runtime_dependency(%q<eventful>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 2.3.2"])
    else
      s.add_dependency(%q<treetop>, [">= 0"])
      s.add_dependency(%q<eventful>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 2.3.2"])
    end
  else
    s.add_dependency(%q<treetop>, [">= 0"])
    s.add_dependency(%q<eventful>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 2.3.2"])
  end
end
