# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'importmap-rails'
require 'stimulus-rails'

Bundler.require(*Rails.groups)
require 'carbon_view_components'

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false

    preview_path = CarbonViewComponents::Engine.root.join('previews').to_s
    config.view_component.preview_paths = [preview_path]
    config.lookbook.preview_paths = [preview_path] if config.respond_to?(:lookbook)
  end
end
