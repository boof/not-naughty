require "rake"
require "rake/clean"
require "rake/gempackagetask"
require "rake/rdoctask"
require "fileutils"
include FileUtils

##############################################################################
# Configuration
##############################################################################
NAME = "not-naughty"
VERS = "0.6.0"
CLEAN.include %w[ pkg doc coverage ]
RDOC_OPTS = [
  "--quiet",
  "--title", "NotNaughty: The Validation Framework",
  "--opname", "index.html",
  "--inline-source",
  "--line-numbers",
  "--main", "README.rdoc",
  "--inline-source",
  "--charset", "utf-8"
]

##############################################################################
# RDoc
##############################################################################
task :doc => [:rdoc]

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = "doc"
  rdoc.options += RDOC_OPTS
  rdoc.main = "README.rdoc"
  rdoc.title = "NotNaughty: The Validation Framework"
  rdoc.rdoc_files.add %w[README.rdoc COPYING CHANGELOG.rdoc lib/**/*.rb]
end

task :doc_rforge => [:doc]

desc "Update docs and upload to rubyforge.org"
task :doc_rforge do
  sh %{scp -r doc/* boof@rubyforge.org:/var/www/gforge-projects/not-naughty}
end

##############################################################################
# specs
##############################################################################
require "spec/rake/spectask"

desc "Run specs with coverage"
Spec::Rake::SpecTask.new("spec") do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts  = File.read("spec/spec.opts").split("\n")
  t.rcov_opts  = File.read("spec/rcov.opts").split("\n")
  t.rcov = true
end

desc "Run specs without coverage"
Spec::Rake::SpecTask.new("spec_no_cov") do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
  t.spec_opts  = File.read("spec/spec.opts").split("\n")
end

desc "check documentation coverage"
task :dcov do
  sh "find lib -name '*.rb' | xargs dcov"
end

##############################################################################
# Gem packaging
##############################################################################
desc "Packages up NotNaughty."
task :default => [:package]
task :package => [:clean]

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.rubyforge_project = NAME
  s.version = VERS
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG.rdoc", "COPYING"]
  s.summary = "Heavily armed validation framework."
  s.description = s.summary
  s.author = "Florian Aßmann"
  s.email = "boof@monkey-patch.me"
  s.homepage = "http://monkey-patch.me/p/notnaughty"
  s.required_ruby_version = ">= 1.8.6"
  s.add_dependency("rubytree", ">= 0.5.2")

  s.files = %w(COPYING README.rdoc Rakefile) + Dir.glob("{spec,lib}/**/*")

  s.require_path = "lib"
end

Rake::GemPackageTask.new(spec) do |p|
  p.need_tar = true
  p.gem_spec = spec
end

##############################################################################
# installation & removal
##############################################################################
task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

task :install_no_docs do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS} --no-rdoc --no-ri}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end

##############################################################################
# gem and rdoc release
##############################################################################
task :release => [:package] do
  sh %{rubyforge login}
  sh %{rubyforge add_release #{NAME} #{NAME} #{VERS} pkg/#{NAME}-#{VERS}.tgz}
  sh %{rubyforge add_file #{NAME} #{NAME} #{VERS} pkg/#{NAME}-#{VERS}.gem}
end

