spec = Gem::Specification.new do |s|
  s.name              = "not-naughty"
  s.version           = "0.6.2"
  s.date              = "2008-10-31"
  s.platform          = Gem::Platform::RUBY
  s.has_rdoc          = true
  s.extra_rdoc_files  = ["README.rdoc", "CHANGELOG.rdoc", "COPYING"]
  s.summary           = "Heavily armed validation framework."
  s.description       = "Heavily armed validation framework."
  s.author            = "Florian Aßmann"
  s.email             = "boof@monkey-patch.me"
  s.homepage          = "http://monkey-patch.me/p/not-naughty"
  s.required_ruby_version = ">= 1.8.6"
  s.add_dependency("rubytree", ">= 0.5.2")

  s.files = %w(COPYING README.rdoc Rakefile) + Dir.glob("lib/**/*")
  s.test_files = Dir.glob("spec/**/*")

  s.require_path = "lib"

  s.rdoc_options = [
    "--quiet",
    "--title", "NotNaughty: The Validation Framework",
    "--opname", "index.html",
    "--inline-source",
    "--line-numbers",
    "--main", "README.rdoc",
    "--inline-source",
    "--charset", "utf-8"
  ]
end
