# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ContentSwitcherComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default content switcher' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option 1')
      end

      assert_selector 'div.cds--content-switcher'
    end

    test 'renders with stimulus controller' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option 1')
      end

      assert_selector 'div[data-controller="carbon--content-switcher"]'
    end

    test 'renders with tablist role' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option 1')
      end

      assert_selector 'div[role="tablist"]'
    end

    # -- Size --

    test 'renders md size (default)' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option')
      end

      assert_no_selector 'div.cds--content-switcher--md'
    end

    test 'renders sm size' do
      render_inline(Carbon::ContentSwitcherComponent.new(size: :sm)) do |c|
        c.with_option(label: 'Option')
      end

      assert_selector 'div.cds--content-switcher--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::ContentSwitcherComponent.new(size: :lg)) do |c|
        c.with_option(label: 'Option')
      end

      assert_selector 'div.cds--content-switcher--lg'
    end

    # -- Option Component --

    test 'renders option buttons' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'First')
        c.with_option(label: 'Second')
        c.with_option(label: 'Third')
      end

      assert_selector 'button.cds--content-switcher-btn[type="button"]', count: 3
    end

    test 'renders option label with inner span wrapper' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'First')
      end

      assert_selector 'button.cds--content-switcher-btn span.cds--content-switcher__label', text: 'First'
    end

    test 'renders selected option' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option A', selected: true)
        c.with_option(label: 'Option B')
      end

      selected_btn = page.find('.cds--content-switcher__label', text: 'Option A').ancestor('button')

      assert_includes selected_btn[:class], 'cds--content-switcher--selected'
      assert_equal 'true', selected_btn['aria-selected']
      assert_equal '0', selected_btn['tabindex']

      unselected_btn = page.find('.cds--content-switcher__label', text: 'Option B').ancestor('button')

      assert_not_includes unselected_btn[:class], 'cds--content-switcher--selected'
      assert_equal 'false', unselected_btn['aria-selected']
      assert_equal '-1', unselected_btn['tabindex']
    end

    test 'renders option with tab role' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option')
      end

      assert_selector 'button[role="tab"]'
    end

    test 'renders option with stimulus action' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option')
      end

      assert_selector 'button[data-action="click->carbon--content-switcher#select"]'
    end

    test 'renders option with stimulus target' do
      render_inline(Carbon::ContentSwitcherComponent.new) do |c|
        c.with_option(label: 'Option')
      end

      assert_selector 'button[data-carbon--content-switcher-target="option"]'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::ContentSwitcherComponent.new(size: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::ContentSwitcherComponent.new(id: 'my-switcher')) do |c|
        c.with_option(label: 'Option')
      end

      assert_selector 'div#my-switcher'
    end

    test 'merges custom class' do
      render_inline(Carbon::ContentSwitcherComponent.new(class: 'custom-switcher')) do |c|
        c.with_option(label: 'Option')
      end

      assert_selector 'div.cds--content-switcher.custom-switcher'
    end
  end
end
