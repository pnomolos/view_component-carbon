# frozen_string_literal: true

require 'view_component'

module CarbonViewComponents
  class Engine < ::Rails::Engine
    isolate_namespace CarbonViewComponents

    initializer 'carbon_view_components.inflections', before: :bootstrap_hook do
      ActiveSupport::Inflector.inflections(:en) do |inflect|
        inflect.acronym 'UI'
      end
    end

    config.autoload_paths << root.join('app/components')
    config.eager_load_paths << root.join('app/components')

    initializer 'carbon_view_components.assets' do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.precompile += %w[carbon_view_components/application.css]
        app.config.assets.paths << root.join('app/components')
      end
    end

    initializer 'carbon_view_components.importmap', before: 'importmap' do |app|
      app.config.importmap.paths << Engine.root.join('config/importmap.rb') if app.config.respond_to?(:importmap)
    end
  end
end
