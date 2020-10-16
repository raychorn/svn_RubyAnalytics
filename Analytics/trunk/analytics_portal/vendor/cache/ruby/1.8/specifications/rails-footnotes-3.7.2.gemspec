# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rails-footnotes}
  s.version = "3.7.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Keenan Brock"]
  s.date = %q{2011-05-02}
  s.description = %q{Every Rails page has footnotes that gives information about your application and links back to your editor.}
  s.email = ["keenan@thebrocks.net"]
  s.files = [".gitignore", "CHANGELOG", "Gemfile", "Gemfile.lock", "MIT-LICENSE", "README.rdoc", "Rakefile", "lib/rails-footnotes.rb", "lib/rails-footnotes/backtracer.rb", "lib/rails-footnotes/footnotes.rb", "lib/rails-footnotes/notes/abstract_note.rb", "lib/rails-footnotes/notes/assigns_note.rb", "lib/rails-footnotes/notes/controller_note.rb", "lib/rails-footnotes/notes/cookies_note.rb", "lib/rails-footnotes/notes/env_note.rb", "lib/rails-footnotes/notes/files_note.rb", "lib/rails-footnotes/notes/filters_note.rb", "lib/rails-footnotes/notes/general_note.rb", "lib/rails-footnotes/notes/javascripts_note.rb", "lib/rails-footnotes/notes/layout_note.rb", "lib/rails-footnotes/notes/log_note.rb", "lib/rails-footnotes/notes/params_note.rb", "lib/rails-footnotes/notes/partials_note.rb", "lib/rails-footnotes/notes/queries_note.rb", "lib/rails-footnotes/notes/routes_note.rb", "lib/rails-footnotes/notes/rpm_note.rb", "lib/rails-footnotes/notes/session_note.rb", "lib/rails-footnotes/notes/stylesheets_note.rb", "lib/rails-footnotes/notes/view_note.rb", "lib/rails-footnotes/version.rb", "rails-footnotes.gemspec", "test/footnotes_test.rb", "test/notes/abstract_note_test.rb", "test/test_helper.rb"]
  s.homepage = %q{http://github.com/josevalim/rails-footnotes}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rails-footnotes}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Every Rails page has footnotes that gives information about your application and links back to your editor.}
  s.test_files = ["test/footnotes_test.rb", "test/notes/abstract_note_test.rb", "test/test_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.0.0"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<rails>, [">= 3.0.0"])
    else
      s.add_dependency(%q<rails>, [">= 3.0.0"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<rails>, [">= 3.0.0"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.0.0"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<rails>, [">= 3.0.0"])
  end
end
