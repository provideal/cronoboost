lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cronoboost/version'

Gem::Specification.new do |spec|
  spec.name          = 'cronoboost'
  spec.version       = Cronoboost::VERSION
  spec.authors       = ['Philipp Hirsch']
  spec.email         = ['itself@hanspolo.net']
  spec.license       = 'MIT'
  spec.summary       = 'Run time-based jobs in background'
  spec.description   = ''
  spec.homepage      = 'https://github.com/provideal/cronoboost'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['cronoboost']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_dependency 'activejob', '~> 5', '>= 5.1'
  spec.add_dependency 'daemons', '~> 1.2', '>= 1.2.6'
  spec.add_dependency 'logger', '~> 1.2', '>= 1.2.8'
  spec.add_dependency 'rails', '~> 5', '>= 5.1'
end
