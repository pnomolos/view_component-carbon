# frozen_string_literal: true

require 'test_helper'

module Carbon
  class MenuComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default menu' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul.cds--menu[role="menu"]'
    end

    test 'renders menu with tabindex -1' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul[tabindex="-1"]'
    end

    test 'renders menu with stimulus controller' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul[data-controller="carbon--menu"]'
    end

    # -- Size --

    test 'renders default size md' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul.cds--menu--md'
    end

    test 'renders xs size' do
      render_inline(Carbon::MenuComponent.new(size: :xs)) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul.cds--menu--xs'
    end

    test 'renders sm size' do
      render_inline(Carbon::MenuComponent.new(size: :sm)) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul.cds--menu--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::MenuComponent.new(size: :lg)) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul.cds--menu--lg'
    end

    # -- Open state --

    test 'renders open menu' do
      render_inline(Carbon::MenuComponent.new(open: true)) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul.cds--menu--open'
    end

    test 'renders closed menu by default' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_no_selector 'ul.cds--menu--open'
    end

    # -- Label --

    test 'renders menu with aria-label' do
      render_inline(Carbon::MenuComponent.new(label: 'Actions')) do |c|
        c.with_item(label: 'Item 1')
      end

      assert_selector 'ul[aria-label="Actions"]'
    end

    # -- Items --

    test 'renders menu items' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Copy')
        c.with_item(label: 'Paste')
      end

      assert_selector 'li.cds--menu-item[role="menuitem"]', count: 2
    end

    test 'renders item with label' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Copy')
      end

      assert_selector '.cds--menu-item__label', text: 'Copy'
    end

    test 'renders item with shortcut' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Copy', shortcut: 'Ctrl+C')
      end

      assert_selector '.cds--menu-item__shortcut', text: 'Ctrl+C'
    end

    test 'does not render shortcut when not provided' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Copy')
      end

      assert_no_selector '.cds--menu-item__shortcut'
    end

    test 'renders disabled item' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Disabled', disabled: true)
      end

      assert_selector 'li.cds--menu-item--disabled[aria-disabled="true"]'
    end

    test 'renders danger item' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Delete', danger: true)
      end

      assert_selector 'li.cds--menu-item--danger'
    end

    # -- Divider --

    test 'renders divider' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_item(label: 'Item 1')
        c.with_divider
        c.with_item(label: 'Item 2')
      end

      assert_selector 'li.cds--menu-item-divider[role="separator"]'
    end

    # -- Group --

    test 'renders group with label' do
      render_inline(Carbon::MenuComponent.new) do |c|
        c.with_group(label: 'Actions') do |group|
          group.with_item(label: 'Copy')
          group.with_item(label: 'Paste')
        end
      end

      assert_selector 'ul.cds--menu-item-group[role="group"][aria-label="Actions"]'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::MenuComponent.new(size: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::MenuComponent.new(id: 'my-menu')) do |c|
        c.with_item(label: 'Item')
      end

      assert_selector 'ul#my-menu'
    end

    test 'merges custom class' do
      render_inline(Carbon::MenuComponent.new(class: 'custom-class')) do |c|
        c.with_item(label: 'Item')
      end

      assert_selector 'ul.cds--menu.custom-class'
    end
  end
end
