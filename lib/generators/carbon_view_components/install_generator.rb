# frozen_string_literal: true

require 'rails/generators'

module CarbonViewComponents
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      desc 'Install Carbon ViewComponents into your Rails application'

      def add_carbon_styles
        # Detect package manager and install @carbon/styles
        if File.exist?(File.join(destination_root, 'pnpm-lock.yaml'))
          run 'pnpm add @carbon/styles'
        elsif File.exist?(File.join(destination_root, 'yarn.lock'))
          run 'yarn add @carbon/styles'
        else
          run 'npm install @carbon/styles'
        end
      end

      def setup_stylesheets
        scss_path = 'app/assets/stylesheets/application.scss'
        carbon_import = "@use '@carbon/styles';\n"
        full_path = File.join(destination_root, scss_path)

        if File.exist?(full_path)
          unless File.read(full_path).include?("@use '@carbon/styles'")
            prepend_to_file scss_path, carbon_import
          end
        else
          create_file scss_path, carbon_import
        end
      end

      def setup_importmap
        return unless File.exist?(File.join(destination_root, 'config/importmap.rb'))

        importmap_content = <<~RUBY

          # Carbon ViewComponents Stimulus controllers
          pin_all_from CarbonViewComponents::Engine.root.join('app/components'),
                       under: 'controllers/carbon',
                       to: 'carbon'
        RUBY

        append_to_file 'config/importmap.rb', importmap_content
      end

      def mount_lookbook
        return unless defined?(Lookbook)

        route_content = <<~RUBY

          if Rails.env.development?
            mount Lookbook::Engine, at: '/lookbook'
          end
        RUBY

        route route_content
      end

      def show_post_install
        say ''
        say 'Carbon ViewComponents installed successfully!', :green
        say ''
        say 'Next steps:'
        say '  1. Ensure dartsass-rails is configured with node_modules in load paths'
        say '  2. Restart your Rails server'
        say '  3. Visit /lookbook to browse component previews (development only)'
        say ''
      end
    end
  end
end
