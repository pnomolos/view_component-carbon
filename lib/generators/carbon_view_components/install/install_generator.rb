# frozen_string_literal: true

module CarbonViewComponents
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Install Carbon ViewComponents into a Rails application"

      def add_carbon_styles_import
        stylesheet = "app/assets/stylesheets/application.scss"

        if File.exist?(stylesheet)
          append_to_file stylesheet, "\n@use 'carbon_view_components';\n"
        else
          create_file stylesheet, "@use 'carbon_view_components';\n"
        end
      end

      def add_dartsass_load_path
        initializer = "config/initializers/dartsass.rb"

        create_file initializer, <<~RUBY
          # frozen_string_literal: true

          # Add node_modules to the Dart Sass load path so @carbon/styles resolves
          Rails.application.config.dartsass.builds["app/assets/stylesheets/application.scss"] = "application.css"

          if defined?(DartSass)
            DartSass.load_paths << Rails.root.join("node_modules")
          end
        RUBY
      end

      def install_node_dependencies
        say "Installing Carbon Design System packages via pnpm..."
        run "pnpm add @carbon/styles @carbon/web-components"
      end

      def mount_lookbook
        return unless Rails.env.development? || options[:force]

        route 'mount Lookbook::Engine, at: "/lookbook" if defined?(Lookbook)'
      end

      def print_post_install
        say ""
        say "Carbon ViewComponents installed successfully!", :green
        say ""
        say "Next steps:"
        say "  1. Ensure dartsass-rails is configured with --load-path=node_modules"
        say "  2. Run `pnpm install` if you haven't already"
        say "  3. Start your server and visit /lookbook for component previews"
        say ""
      end
    end
  end
end
