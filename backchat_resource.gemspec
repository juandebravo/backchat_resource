# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{backchat_resource}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Adam Burmister"]
  s.date = %q{2011-04-02}
  s.description = %q{An ActiveRecord wrapper around the BackChat.io RESTful API}
  s.email = %q{adam.burmister@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "lib/backchat_resource.rb",
    "lib/backchat_resource/backchat_json_format.rb",
    "lib/backchat_resource/base.rb",
    "lib/backchat_resource/backchat_uri.rb",
    "lib/backchat_resource/config.yml",
    "lib/backchat_resource/exceptions.rb",
    "lib/backchat_resource/models.rb",
    "lib/backchat_resource/models/channel.rb",
    "lib/backchat_resource/models/channel_filter.rb",
    "lib/backchat_resource/models/plan.rb",
    "lib/backchat_resource/models/source.rb",
    "lib/backchat_resource/models/stream.rb",
    "lib/backchat_resource/models/user.rb",
    "lib/backchat_resource/string_extensions.rb",
    "lib/backchat_resource/version.rb",
    "lib/rcov/file_statistics.rb",
    "spec/backchat_resource_spec.rb",
    "spec/channel_filter_spec.rb",
    "spec/channel_spec.rb",
    "spec/fakeweb_routes.rb",
    "spec/fixtures/forgot.json",
    "spec/fixtures/generate_api_key.json",
    "spec/fixtures/login.json",
    "spec/fixtures/plan_amazon.json",
    "spec/fixtures/plan_free.json",
    "spec/fixtures/plans.json",
    "spec/fixtures/sources.json",
    "spec/fixtures/stream_mojolly-crew.json",
    "spec/plan_spec.rb",
    "spec/source_spec.rb",
    "spec/spec_helper.rb",
    "spec/stream_spec.rb",
    "spec/user_spec.rb"
  ]
  s.homepage = %q{http://github.com/adamburmister/backchat_resource}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An ActiveRecord wrapper around the BackChat.io RESTful API}
  s.test_files = [
    "spec/backchat_resource_spec.rb",
    "spec/backchat_uri_spec.rb",
    "spec/channel_filter_spec.rb",
    "spec/channel_spec.rb",
    "spec/fakeweb_routes.rb",
    "spec/plan_spec.rb",
    "spec/source_spec.rb",
    "spec/spec_helper.rb",
    "spec/stream_spec.rb",
    "spec/user_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activeresource>, [">= 0"])
      s.add_runtime_dependency(%q<unidecode>, [">= 0"])
      s.add_runtime_dependency(%q<reactive_resource>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<autotest>, [">= 0"])
      s.add_development_dependency(%q<autotest-fsevent>, [">= 0"])
      s.add_development_dependency(%q<fakeweb>, [">= 0"])
      s.add_development_dependency(%q<fuubar>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<activeresource>, [">= 0"])
      s.add_dependency(%q<unidecode>, [">= 0"])
      s.add_dependency(%q<reactive_resource>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<autotest>, [">= 0"])
      s.add_dependency(%q<autotest-fsevent>, [">= 0"])
      s.add_dependency(%q<fakeweb>, [">= 0"])
      s.add_dependency(%q<fuubar>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<activeresource>, [">= 0"])
    s.add_dependency(%q<unidecode>, [">= 0"])
    s.add_dependency(%q<reactive_resource>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<autotest>, [">= 0"])
    s.add_dependency(%q<autotest-fsevent>, [">= 0"])
    s.add_dependency(%q<fakeweb>, [">= 0"])
    s.add_dependency(%q<fuubar>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end

