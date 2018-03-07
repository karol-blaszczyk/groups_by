
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'groups_by/version'

Gem::Specification.new do |spec|
  spec.name          = 'groups_by'
  spec.version       = GroupsBy::VERSION
  spec.authors       = ['Karol Błaszczyk']
  spec.email         = ['karol.zygmunt.blaszczyk@gmail.com']

  spec.summary       = 'groups_by'
  spec.description   = '#group_by with multiple grouping rules.'
  spec.homepage      = 'https://github.com/karol-blaszczyk/groups_by'
  spec.license       = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
