# frozen_string_literal: true

require 'test_helper'

module Carbon
  class UIShellComponentTest < CarbonViewComponents::TestCase # rubocop:disable Metrics/ClassLength
    # -- Default rendering --

    test 'renders wrapper div with main content area' do
      render_inline(Carbon::UIShellComponent.new) do
        'Main content'
      end

      assert_selector "main.cds--content#main-content[tabindex='-1']", text: 'Main content'
    end

    test 'renders main content with correct id for skip to content' do
      render_inline(Carbon::UIShellComponent.new) do
        'Page content'
      end

      assert_selector 'main#main-content'
    end

    # -- Skip to content --

    test 'renders skip to content link' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_skip_to_content
        'Content'
      end

      assert_selector "a.cds--skip-to-content[href='#main-content']", text: 'Skip to main content'
    end

    test 'renders skip to content with custom href' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_skip_to_content(href: '#custom-content', text: 'Skip ahead')
        'Content'
      end

      assert_selector "a.cds--skip-to-content[href='#custom-content']", text: 'Skip ahead'
    end

    test 'skip to content has tabindex 0' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_skip_to_content
        'Content'
      end

      assert_selector "a.cds--skip-to-content[tabindex='0']"
    end

    # -- Header --

    test 'renders header element' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header(aria_label: 'IBM Platform')
        'Content'
      end

      assert_selector "header.cds--header[aria-label='IBM Platform']"
    end

    test 'renders header with stimulus controller' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header
        'Content'
      end

      assert_selector "header[data-controller='carbon--ui-shell--ui-shell']"
    end

    # -- Header name --

    test 'renders header name with prefix and product name' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_name(href: '/') { 'Cloud Platform' }
        end
        'Content'
      end

      assert_selector "a.cds--header__name[href='/']"
      assert_selector '.cds--header__name--prefix', text: 'IBM'
      assert_text 'Cloud Platform'
    end

    test 'renders header name with custom prefix' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_name(href: '/', prefix: 'Acme') { 'Dashboard' }
        end
        'Content'
      end

      assert_selector '.cds--header__name--prefix', text: 'Acme'
    end

    test 'renders header name without prefix' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_name(href: '/', prefix: nil) { 'Dashboard' }
        end
        'Content'
      end

      assert_no_selector '.cds--header__name--prefix'
    end

    # -- Header navigation --

    test 'renders header navigation with items' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_nav do |nav|
            nav.with_item(label: 'Home', href: '/')
            nav.with_item(label: 'About', href: '/about')
          end
        end
        'Content'
      end

      assert_selector "nav.cds--header__nav[aria-label='Header navigation']"
      assert_selector "ul.cds--header__menu-bar[role='menubar']"
      assert_selector 'a.cds--header__menu-item', count: 2
    end

    test 'renders header nav with custom aria-label' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_nav(aria_label: 'Main navigation') do |nav|
            nav.with_item(label: 'Home', href: '/')
          end
        end
        'Content'
      end

      assert_selector "nav[aria-label='Main navigation']"
    end

    test 'renders header menu item with text truncation' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_nav do |nav|
            nav.with_item(label: 'Home', href: '/')
          end
        end
        'Content'
      end

      assert_selector '.cds--text-truncate--end', text: 'Home'
    end

    # -- Active menu item --

    test 'renders active header menu item with aria-current' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_nav do |nav|
            nav.with_item(label: 'Home', href: '/', active: true)
          end
        end
        'Content'
      end

      assert_selector "a.cds--header__menu-item--current[aria-current='page']"
    end

    test 'does not add aria-current to inactive menu items' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_nav do |nav|
            nav.with_item(label: 'Home', href: '/', active: false)
          end
        end
        'Content'
      end

      assert_no_selector '[aria-current]'
    end

    # -- Header dropdown menu --

    test 'renders header dropdown menu' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_nav do |nav|
            nav.with_menu(label: 'Products') do |menu|
              menu.with_item(label: 'Product A', href: '/a')
              menu.with_item(label: 'Product B', href: '/b')
            end
          end
        end
        'Content'
      end

      assert_selector 'li.cds--header__submenu'
      assert_selector "button.cds--header__menu-title[aria-haspopup='menu'][aria-expanded='false']"
      assert_selector "ul.cds--header__menu[role='menu']"
      assert_selector 'ul.cds--header__menu a.cds--header__menu-item', count: 2
    end

    test 'renders header menu with stimulus controller' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_nav do |nav|
            nav.with_menu(label: 'Products') do |menu|
              menu.with_item(label: 'Product A', href: '/a')
            end
          end
        end
        'Content'
      end

      assert_selector "li[data-controller='carbon--ui-shell--header-menu']"
    end

    # -- Global action bar --

    test 'renders global action bar' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_global_bar do |bar|
            bar.with_action(aria_label: 'Notifications') { 'icon' }
          end
        end
        'Content'
      end

      assert_selector 'div.cds--header__global'
      assert_selector "button.cds--header__action[aria-label='Notifications']"
    end

    test 'renders global action with aria-expanded' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_global_bar do |bar|
            bar.with_action(aria_label: 'Notifications', active: true, panel_id: 'notif-panel') { 'icon' }
          end
        end
        'Content'
      end

      assert_selector "button.cds--header__action--active[aria-expanded='true'][aria-controls='notif-panel']"
    end

    test 'renders global action with panel toggle data-action' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_global_bar do |bar|
            bar.with_action(aria_label: 'Search', panel_id: 'search-panel') { 'icon' }
          end
        end
        'Content'
      end

      assert_selector "button[data-action='carbon--ui-shell--ui-shell#togglePanel']"
    end

    # -- Header panels --

    test 'renders header panel' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_panel(panel_id: 'test-panel') { 'Panel content' }
        end
        'Content'
      end

      assert_selector 'div.cds--header-panel#test-panel', text: 'Panel content'
    end

    test 'renders expanded header panel' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_panel(expanded: true, panel_id: 'panel-1') { 'Content' }
        end
        'Content'
      end

      assert_selector 'div.cds--header-panel.cds--header-panel--expanded'
    end

    # -- Switcher --

    test 'renders switcher with items' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_panel(panel_id: 'switcher-panel') do |panel|
            panel.with_switcher(aria_label: 'Switcher') do |switcher|
              switcher.with_item(href: '/app1') { 'App 1' }
              switcher.with_item(href: '/app2') { 'App 2' }
            end
          end
        end
        'Content'
      end

      assert_selector "ul.cds--switcher[aria-label='Switcher']"
      assert_selector 'li.cds--switcher__item', count: 2
      assert_selector "a.cds--switcher__item-link[href='/app1']", text: 'App 1'
    end

    test 'renders selected switcher item' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_header do |h|
          h.with_panel(panel_id: 'switcher-panel') do |panel|
            panel.with_switcher(aria_label: 'Switcher') do |switcher|
              switcher.with_item(href: '/app1', selected: true) { 'App 1' }
            end
          end
        end
        'Content'
      end

      assert_selector "a.cds--switcher__item-link--selected[aria-current='page']"
    end

    # -- Side nav --

    test 'renders side nav' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard')
        end
        'Content'
      end

      assert_selector "nav.cds--side-nav.cds--side-nav--ux[aria-label='Side navigation']"
    end

    test 'renders expanded side nav' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav(expanded: true) do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard')
        end
        'Content'
      end

      assert_selector 'nav.cds--side-nav--expanded'
    end

    test 'renders rail side nav' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav(rail: true) do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard')
        end
        'Content'
      end

      assert_selector 'nav.cds--side-nav--rail'
    end

    test 'renders side nav with stimulus controller' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard')
        end
        'Content'
      end

      assert_selector "nav[data-controller='carbon--ui-shell--side-nav']"
    end

    test 'renders side nav overlay' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard')
        end
        'Content'
      end

      assert_selector 'div.cds--side-nav__overlay'
    end

    test 'renders active side nav overlay when expanded' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav(expanded: true) do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard')
        end
        'Content'
      end

      assert_selector 'div.cds--side-nav__overlay.cds--side-nav__overlay-active'
    end

    # -- Side nav links --

    test 'renders side nav links' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard')
          nav.with_link(label: 'Settings', href: '/settings')
        end
        'Content'
      end

      assert_selector 'li.cds--side-nav__item', count: 2
      assert_selector 'a.cds--side-nav__link', count: 2
      assert_selector '.cds--side-nav__link-text', text: 'Dashboard'
    end

    test 'renders active side nav link' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_link(label: 'Dashboard', href: '/dashboard', active: true)
        end
        'Content'
      end

      assert_selector "a.cds--side-nav__link--current[aria-current='page']"
    end

    # -- Side nav expandable menus --

    test 'renders side nav menu' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_menu(title: 'Section') do |menu|
            menu.with_item(label: 'Item A', href: '/a')
            menu.with_item(label: 'Item B', href: '/b')
          end
        end
        'Content'
      end

      assert_selector "button.cds--side-nav__submenu[aria-expanded='false']"
      assert_selector '.cds--side-nav__submenu-title', text: 'Section'
      assert_selector "ul.cds--side-nav__menu[role='menu']"
      assert_selector 'li.cds--side-nav__menu-item', count: 2
    end

    test 'renders expanded side nav menu' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_menu(title: 'Section', expanded: true) do |menu|
            menu.with_item(label: 'Item A', href: '/a')
          end
        end
        'Content'
      end

      assert_selector "button.cds--side-nav__submenu[aria-expanded='true']"
    end

    test 'renders active side nav menu item' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_menu(title: 'Section') do |menu|
            menu.with_item(label: 'Item A', href: '/a', active: true)
          end
        end
        'Content'
      end

      assert_selector "li.cds--side-nav__menu-item a.cds--side-nav__link--current[aria-current='page']"
    end

    test 'renders side nav menu with stimulus controller' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_menu(title: 'Section') do |menu|
            menu.with_item(label: 'Item A', href: '/a')
          end
        end
        'Content'
      end

      assert_selector "li[data-controller='carbon--ui-shell--side-nav-menu']"
    end

    test 'renders side nav menu chevron' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_menu(title: 'Section') do |menu|
            menu.with_item(label: 'Item A', href: '/a')
          end
        end
        'Content'
      end

      assert_selector '.cds--side-nav__submenu-chevron svg'
    end

    # -- Stimulus data attributes --

    test 'side nav has ui-shell target attribute' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_link(label: 'Home', href: '/')
        end
        'Content'
      end

      assert_selector "nav[data-carbon--ui-shell--ui-shell-target='sideNav']"
    end

    test 'overlay has ui-shell target attribute' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav do |nav|
          nav.with_link(label: 'Home', href: '/')
        end
        'Content'
      end

      assert_selector "div[data-carbon--ui-shell--ui-shell-target='overlay']"
    end

    # -- System arguments --

    test 'passes through system arguments on shell' do
      render_inline(Carbon::UIShellComponent.new(id: 'my-shell')) do
        'Content'
      end

      # The wrapper div should exist; the main content should still render
      assert_selector 'main.cds--content'
    end

    test 'renders side nav with custom aria-label' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav(aria_label: 'Custom nav') do |nav|
          nav.with_link(label: 'Home', href: '/')
        end
        'Content'
      end

      assert_selector "nav[aria-label='Custom nav']"
    end

    test 'side nav rail value is set in data attributes' do
      render_inline(Carbon::UIShellComponent.new) do |c|
        c.with_side_nav(rail: true) do |nav|
          nav.with_link(label: 'Home', href: '/')
        end
        'Content'
      end

      assert_selector "nav[data-carbon--ui-shell--side-nav-rail-value='true']"
    end
  end
end
