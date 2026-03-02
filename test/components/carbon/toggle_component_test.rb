# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ToggleComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default toggle' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'div.cds--toggle'
      assert_selector 'button.cds--toggle__button[role="switch"][type="button"]'
    end

    test 'renders with stimulus controller' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'div[data-controller="carbon--toggle"]'
    end

    test 'does not render cds--form-item wrapper' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector '.cds--form-item'
    end

    # -- Size --

    test 'renders md size (default) with no size modifier on appearance' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector '.cds--toggle__appearance--sm'
    end

    test 'renders sm size with appearance modifier' do
      render_inline(Carbon::ToggleComponent.new(size: :sm))

      assert_selector '.cds--toggle__appearance--sm'
    end

    # -- Toggled state --

    test 'renders unchecked by default' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'button[aria-checked="false"]'
      assert_no_selector '.cds--toggle__switch--checked'
    end

    test 'renders checked when toggled is true' do
      render_inline(Carbon::ToggleComponent.new(toggled: true))

      assert_selector 'button[aria-checked="true"]'
      assert_selector '.cds--toggle__switch--checked'
    end

    # -- Disabled state --

    test 'renders enabled by default' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector 'button[disabled]'
      assert_no_selector '.cds--toggle--disabled'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::ToggleComponent.new(disabled: true))

      assert_selector 'button[disabled]'
      assert_selector '.cds--toggle--disabled'
    end

    # -- Readonly state --

    test 'renders not readonly by default' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector 'button[readonly]'
      assert_no_selector '.cds--toggle--readonly'
    end

    test 'renders readonly when readonly is true' do
      render_inline(Carbon::ToggleComponent.new(readonly: true))

      assert_selector 'button[readonly]'
      assert_selector '.cds--toggle--readonly'
    end

    # -- Labels --

    test 'renders current text based on toggle state' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__text[aria-hidden="true"]', text: 'Off'
    end

    test 'renders On text when toggled' do
      render_inline(Carbon::ToggleComponent.new(toggled: true))

      assert_selector '.cds--toggle__text[aria-hidden="true"]', text: 'On'
    end

    test 'renders custom label_a' do
      render_inline(Carbon::ToggleComponent.new(label_a: 'No'))

      assert_selector '.cds--toggle__text', text: 'No'
    end

    test 'renders custom label_b when toggled' do
      render_inline(Carbon::ToggleComponent.new(label_b: 'Yes', toggled: true))

      assert_selector '.cds--toggle__text', text: 'Yes'
    end

    test 'renders label_text when provided' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Enable feature'))

      assert_selector '.cds--toggle__label-text', text: 'Enable feature'
    end

    test 'does not render label_text when not provided' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector '.cds--toggle__label-text'
    end

    test 'hides label when hide_label is true' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Hidden', hide_label: true))

      assert_selector '.cds--toggle__label-text.cds--visually-hidden', text: 'Hidden'
    end

    # -- Appearance wrapper --

    test 'renders appearance wrapper' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__appearance'
    end

    # -- Switch element --

    test 'renders switch element' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__switch'
    end

    test 'renders checkmark SVG icon inside switch' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__switch svg.cds--toggle__check'
    end

    test 'renders single toggle text with aria-hidden' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__text[aria-hidden="true"]'
      assert_no_selector '.cds--toggle__text--off'
      assert_no_selector '.cds--toggle__text--on'
    end

    # -- Button attributes --

    test 'button has aria-labelledby pointing to label' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Test'))

      button = page.find('button.cds--toggle__button')
      label_id = button['aria-labelledby']

      assert_selector "label##{label_id}"
    end

    test 'label for attribute matches button id' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Test'))

      button = page.find('button.cds--toggle__button')
      label = page.find('label.cds--toggle__label')

      assert_equal button['id'], label['for']
    end

    # -- Stimulus --

    test 'renders button with stimulus action' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'button[data-action="click->carbon--toggle#toggle"]'
    end

    test 'renders button with stimulus target' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'button[data-carbon--toggle-target="button"]'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::ToggleComponent.new(size: :invalid)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::ToggleComponent.new(id: 'my-toggle'))

      assert_selector 'div#my-toggle'
    end

    test 'merges custom class' do
      render_inline(Carbon::ToggleComponent.new(class: 'custom-toggle'))

      assert_selector 'div.cds--toggle.custom-toggle'
    end
  end
end
