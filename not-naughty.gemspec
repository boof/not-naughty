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

  s.files = %w(COPYING README.rdoc Rakefile) + ["lib/core_extensions.rb", "lib/not_naughty", "lib/not_naughty/class_methods.rb", "lib/not_naughty/error_handler.rb", "lib/not_naughty/instance_methods.rb", "lib/not_naughty/validation.rb", "lib/not_naughty/validations", "lib/not_naughty/validations/acceptance_validation.rb", "lib/not_naughty/validations/confirmation_validation.rb", "lib/not_naughty/validations/format_validation.rb", "lib/not_naughty/validations/length_validation.rb", "lib/not_naughty/validations/numericality_validation.rb", "lib/not_naughty/validations/presence_validation.rb", "lib/not_naughty/validator.rb", "lib/not_naughty/violation.rb", "lib/not_naughty.rb"]
  s.test_files = ["spec/class_methods_spec.rb", "spec/error_handler_spec.rb", "spec/not_naughty_spec.rb", "spec/rcov.opts", "spec/spec.opts", "spec/spec_helper.rb", "spec/validation_spec.rb", "spec/validations_spec.rb", "spec/validator_spec.rb", "spec/violation_spec.rb"]

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
