# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ToggleComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default toggle' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'div.cds--form-item'
      assert_selector 'div.cds--toggle'
      assert_selector 'input.cds--toggle__input[type="checkbox"][role="switch"]'
    end

    test 'renders with stimulus controller' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'div[data-controller="carbon--toggle"]'
    end

    # -- Size --

    test 'renders md size (default)' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector '.cds--toggle--md'
    end

    test 'renders sm size' do
      render_inline(Carbon::ToggleComponent.new(size: :sm))

      assert_selector '.cds--toggle--sm'
    end

    # -- Toggled state --

    test 'renders unchecked by default' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector 'input[checked]'
      assert_selector 'input[aria-checked="false"]'
    end

    test 'renders checked when toggled is true' do
      render_inline(Carbon::ToggleComponent.new(toggled: true))

      assert_selector 'input[checked]'
      assert_selector 'input[aria-checked="true"]'
    end

    # -- Disabled state --

    test 'renders enabled by default' do
      render_inline(Carbon::ToggleComponent.new)

      assert_no_selector 'input[disabled]'
    end

    test 'renders disabled when disabled is true' do
      render_inline(Carbon::ToggleComponent.new(disabled: true))

      assert_selector 'input[disabled]'
    end

    # -- Labels --

    test 'renders default off/on labels' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__text--off', text: 'Off'
      assert_selector '.cds--toggle__text--on', text: 'On'
    end

    test 'renders custom label_a' do
      render_inline(Carbon::ToggleComponent.new(label_a: 'No'))

      assert_selector '.cds--toggle__text--off', text: 'No'
    end

    test 'renders custom label_b' do
      render_inline(Carbon::ToggleComponent.new(label_b: 'Yes'))

      assert_selector '.cds--toggle__text--on', text: 'Yes'
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

    # -- Input ID --

    test 'generates unique input id' do
      render_inline(Carbon::ToggleComponent.new(label_text: 'Test'))

      label = page.find('label.cds--toggle__label')
      input_id = label['for']

      assert_selector "input##{input_id}"
    end

    # -- Stimulus --

    test 'renders input with stimulus action' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'input[data-action="change->carbon--toggle#change"]'
    end

    test 'renders input with stimulus target' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector 'input[data-carbon--toggle-target="input"]'
    end

    # -- Switch element --

    test 'renders switch element' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__switch'
    end

    test 'renders off and on text with aria-hidden' do
      render_inline(Carbon::ToggleComponent.new)

      assert_selector '.cds--toggle__text--off[aria-hidden="true"]'
      assert_selector '.cds--toggle__text--on[aria-hidden="true"]'
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

      assert_selector 'div.cds--form-item.custom-toggle'
    end
  end
end
