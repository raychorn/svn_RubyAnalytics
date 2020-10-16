# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_singleton}
  s.version = "0.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Celis"]
  s.date = %q{2010-07-27}
  s.description = %q{It just makes sense to store mutable, site-wide, admin-level settings in the database. Right? A key-value table may be more flexible, but maybe we don't want to be flexible! If you truly want that flexibility: http://github.com/stephencelis/kvc}
  s.email = %q{stephen@stephencelis.com}
  s.extra_rdoc_files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.files = ["History.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "init.rb", "lib/acts_as_singleton.rb", "test/acts_as_singleton_test.rb"]
  s.homepage = %q{http://github.com/stephencelis/acts_as_singleton}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{A lightweight singleton library for your Active Record models.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
  end
end
