# frozen_string_literal: true

module Carbon
  class UIShellComponentPreview < ViewComponent::Preview
    # @label Default
    def default # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      render Carbon::UIShellComponent.new do |c| # rubocop:disable Metrics/BlockLength
        c.with_skip_to_content
        c.with_header(aria_label: 'IBM Platform') do |h|
          h.with_name(href: '/') { 'Cloud Platform' }
          h.with_nav do |nav|
            nav.with_item(label: 'Link 1', href: '#', active: true)
            nav.with_item(label: 'Link 2', href: '#')
            nav.with_item(label: 'Link 3', href: '#')
            nav.with_menu(label: 'More') do |menu|
              menu.with_item(label: 'Sub-link 1', href: '#')
              menu.with_item(label: 'Sub-link 2', href: '#')
            end
          end
          h.with_global_bar do |bar|
            bar.with_action(aria_label: 'Notifications', panel_id: 'notifications-panel') do
              tag.svg(width: '20', height: '20', viewBox: '0 0 32 32') do
                tag.path(fill: 'currentColor',
                         d: 'M28.7 20.3L26 17.6V13a10 10 0 0 0-8-9.8V1h-4v2.2A10 10 ' \
                            '0 0 0 6 13v4.6l-2.7 2.7A1 1 0 0 0 4 22h7v1a5 5 0 0 0 ' \
                            '10 0v-1h7a1 1 0 0 0 .7-1.7z')
              end
            end
          end
          h.with_panel(panel_id: 'notifications-panel') do
            tag.div('Notifications panel content', style: 'padding: 1rem;')
          end
        end
        tag.div(style: 'padding: 2rem;') do
          safe_join([tag.h1('Main content'), tag.p('This is the main content area.')])
        end
      end
    end

    # @label With Side Nav
    def with_side_nav # rubocop:disable Metrics/AbcSize
      render Carbon::UIShellComponent.new do |c|
        c.with_skip_to_content
        c.with_header(aria_label: 'IBM Platform') do |h|
          h.with_name(href: '/') { 'Cloud Platform' }
        end
        c.with_side_nav(expanded: true) do |nav|
          nav.with_link(label: 'Dashboard', href: '#', active: true)
          nav.with_link(label: 'Overview', href: '#')
          nav.with_menu(title: 'Category') do |menu|
            menu.with_item(label: 'Item A', href: '#')
            menu.with_item(label: 'Item B', href: '#')
            menu.with_item(label: 'Item C', href: '#', active: true)
          end
          nav.with_link(label: 'Settings', href: '#')
        end
        tag.div(style: 'padding: 2rem;') do
          safe_join([tag.h1('Side nav example'), tag.p('Content area with side navigation.')])
        end
      end
    end

    # @label Rail Side Nav
    def rail_side_nav
      render Carbon::UIShellComponent.new do |c|
        c.with_header(aria_label: 'IBM Platform') do |h|
          h.with_name(href: '/') { 'Cloud Platform' }
        end
        c.with_side_nav(rail: true) do |nav|
          nav.with_link(label: 'Dashboard', href: '#', active: true)
          nav.with_link(label: 'Settings', href: '#')
        end
        tag.div(tag.h1('Rail nav example'), style: 'padding: 2rem;')
      end
    end

    # @label With Switcher
    def with_switcher # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      render Carbon::UIShellComponent.new do |c|
        c.with_header(aria_label: 'IBM Platform') do |h|
          h.with_name(href: '/') { 'Cloud Platform' }
          h.with_global_bar do |bar|
            bar.with_action(aria_label: 'App Switcher', panel_id: 'switcher-panel') do
              tag.svg(width: '20', height: '20', viewBox: '0 0 32 32') do
                tag.path(fill: 'currentColor',
                         d: 'M14 4H4v10h10zM12 12H6V6h6zM28 4H18v10h10z' \
                            'M26 12h-6V6h6zM14 18H4v10h10zM12 26H6v-6h6z' \
                            'M28 18H18v10h10zM26 26h-6v-6h6z')
              end
            end
          end
          h.with_panel(panel_id: 'switcher-panel') do |panel|
            panel.with_switcher(aria_label: 'Switcher') do |switcher|
              switcher.with_item(href: '#', selected: true) { 'My Cloud' }
              switcher.with_item(href: '#') { 'All Products' }
              switcher.with_item(href: '#') { 'My Account' }
            end
          end
        end
        tag.div(tag.h1('Switcher example'), style: 'padding: 2rem;')
      end
    end
  end
end
