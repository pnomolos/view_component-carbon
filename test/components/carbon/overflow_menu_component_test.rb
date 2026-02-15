# frozen_string_literal: true

require 'test_helper'

module Carbon
  class OverflowMenuComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default overflow menu' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'div.cds--overflow-menu[data-controller="carbon--overflow-menu"]'
    end

    test 'renders trigger button' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'button.cds--overflow-menu__trigger[type="button"]'
      assert_selector 'button[aria-haspopup="true"]'
      assert_selector 'button[aria-expanded="false"]'
    end

    test 'renders kebab icon' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'svg.cds--overflow-menu__icon'
    end

    test 'renders menu list' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'ul.cds--overflow-menu-options[role="menu"]'
    end

    # -- Icon description --

    test 'renders default icon description' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'button[aria-label="Options"]'
    end

    test 'renders custom icon description' do
      render_inline(Carbon::OverflowMenuComponent.new(icon_description: 'More actions')) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'button[aria-label="More actions"]'
    end

    # -- Size --

    test 'renders default size without class' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_no_selector 'div.cds--overflow-menu--md'
    end

    test 'renders sm size' do
      render_inline(Carbon::OverflowMenuComponent.new(size: :sm)) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'div.cds--overflow-menu--sm'
    end

    # -- Flipped --

    test 'renders flipped menu' do
      render_inline(Carbon::OverflowMenuComponent.new(flipped: true)) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_selector 'ul.cds--overflow-menu--flip'
    end

    test 'renders non-flipped menu by default' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
      end

      assert_no_selector 'ul.cds--overflow-menu--flip'
    end

    # -- Items --

    test 'renders menu items' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option 1')
        c.with_item(text: 'Option 2')
      end

      assert_selector 'li.cds--overflow-menu-options__option', count: 2
    end

    test 'renders item with text' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'My Option')
      end

      assert_selector '.cds--overflow-menu-options__option-content', text: 'My Option'
    end

    test 'renders item as button by default' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Option')
      end

      assert_selector 'button.cds--overflow-menu-options__btn[role="menuitem"][type="button"]'
    end

    test 'renders item as link when href provided' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Link Option', href: '/some-path')
      end

      assert_selector 'a.cds--overflow-menu-options__btn[role="menuitem"][href="/some-path"]'
    end

    test 'renders disabled item' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Disabled', disabled: true)
      end

      assert_selector 'li.cds--overflow-menu-options__option--disabled'
      assert_selector 'button[disabled]'
    end

    test 'renders danger item' do
      render_inline(Carbon::OverflowMenuComponent.new) do |c|
        c.with_item(text: 'Delete', danger: true)
      end

      assert_selector 'li.cds--overflow-menu-options__option--danger'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::OverflowMenuComponent.new(size: :invalid)
      end
    end

    test 'raises ArgumentError for invalid align' do
      assert_raises(ArgumentError) do
        Carbon::OverflowMenuComponent.new(align: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::OverflowMenuComponent.new(id: 'my-overflow')) do |c|
        c.with_item(text: 'Option')
      end

      assert_selector 'div#my-overflow'
    end

    test 'merges custom class' do
      render_inline(Carbon::OverflowMenuComponent.new(class: 'custom-class')) do |c|
        c.with_item(text: 'Option')
      end

      assert_selector 'div.cds--overflow-menu.custom-class'
    end
  end
end
