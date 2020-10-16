# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{methodphitamine}
  s.version = "1.0.0"

  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.authors = ["Jay Phillips"]
  s.cert_chain = nil
  s.date = %q{2007-08-04}
  s.description = %q{The Methodphitamine! Creates the implied block argument "it" which makes the refining and enumerating of collections much simpler. For example, User.find(:all).collect &its.contacts.map(&its.last_name.capitalize)}
  s.email = %q{jay-at-codemecca.com}
  s.extra_rdoc_files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "website/index.txt"]
  s.files = ["History.txt", "License.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/methodphitamine.rb", "lib/methodphitamine/it_class.rb", "lib/methodphitamine/monkey_patches.rb", "lib/methodphitamine/version.rb", "scripts/txt2html", "spec/methodphitamine_spec.rb", "spec/rspec_compatibility_spec.rb", "website/index.html", "website/index.txt", "website/javascripts/rounded_corners_lite.inc.js", "website/stylesheets/screen.css", "website/template.rhtml"]
  s.homepage = %q{http://methodphitamine.rubyforge.org}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = %q{methodphitamine}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{The Methodphitamine! Creates the implied block argument "it" which makes the refining and enumerating of collections much simpler. For example, User.find(:all).collect &its.contacts.map(&its.last_name.capitalize)}

  if s.respond_to? :specification_version then
    s.specification_version = 1

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
