# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{capinatra}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = %q{2008-12-21}
  s.default_executable = %q{capinatra}
  s.executables = ["capinatra"]
  s.files = [
    "bin/capinatra",
    "lib/capinatra.rb",
    "templates/Capfile",
    "templates/config.ru.erb",
    "templates/vhost.conf.erb"
  ]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Quickly deploy Sinatra apps on Passenger}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, [">= 0"])
    else
      s.add_dependency(%q<capistrano>, [">= 0"])
    end
  else
    s.add_dependency(%q<capistrano>, [">= 0"])
  end
end
