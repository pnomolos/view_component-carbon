# frozen_string_literal: true

require 'view_component'

module CarbonViewComponents
  class Engine < ::Rails::Engine
    isolate_namespace CarbonViewComponents

    config.autoload_paths << root.join('app/components')
    config.eager_load_paths << root.join('app/components')

    initializer 'carbon_view_components.assets' do |app|
      app.config.assets.precompile += %w[carbon_view_components/application.css] if app.config.respond_to?(:assets)
    end

    initializer 'carbon_view_components.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << Engine.root.join('config/importmap.rb') if app.config.respond_to?(:importmap)
    end
  end
end
