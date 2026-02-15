# frozen_string_literal: true

require_relative 'lib/carbon_view_components/version'

Gem::Specification.new do |spec|
  spec.name          = 'carbon_view_components'
  spec.version       = CarbonViewComponents::VERSION
  spec.authors       = ['Carbon ViewComponents Contributors']
  spec.summary       = 'ViewComponents for the Carbon Design System'
  spec.description   = "Rails ViewComponent implementations of IBM's Carbon Design System " \
                       'with Stimulus and optional WebComponent interactivity.'
  spec.homepage      = 'https://github.com/pnomolos/view_component-carbon'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri']   = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['{app,lib,config,previews}/**/*', 'LICENSE', 'README.md']
  spec.require_paths = ['lib']

  spec.add_dependency 'actionview', '>= 7.2.0'
  spec.add_dependency 'activesupport', '>= 7.2.0'
  spec.add_dependency 'view_component', '>= 3.1', '< 5.0'
end
