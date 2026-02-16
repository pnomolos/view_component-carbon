# frozen_string_literal: true

require 'test_helper'

module Carbon
  class SelectableTileComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default selectable tile' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'div.cds--tile.cds--tile--selectable[role="checkbox"]'
    end

    test 'renders div with checkbox role' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'div[role="checkbox"]'
    end

    test 'renders content in tile-content div' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Selectable content' }

      assert_selector '.cds--tile-content', text: 'Selectable content'
    end

    # -- Selected state --

    test 'renders selected class when selected' do
      render_inline(Carbon::SelectableTileComponent.new(selected: true)) { 'Content' }

      assert_selector 'div.cds--tile--is-selected'
    end

    test 'renders aria-checked true when selected' do
      render_inline(Carbon::SelectableTileComponent.new(selected: true)) { 'Content' }

      assert_selector 'div[aria-checked="true"]'
    end

    test 'renders aria-checked false by default' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'div[aria-checked="false"]'
    end

    # -- Disabled state --

    test 'renders disabled class when disabled' do
      render_inline(Carbon::SelectableTileComponent.new(disabled: true)) { 'Content' }

      assert_selector 'div.cds--tile--disabled'
    end

    test 'does not render tabindex when disabled' do
      render_inline(Carbon::SelectableTileComponent.new(disabled: true)) { 'Content' }

      assert_selector 'div[role="checkbox"]:not([tabindex])'
    end

    test 'renders tabindex 0 when not disabled' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'div[role="checkbox"][tabindex="0"]'
    end

    # -- Form attributes --

    test 'renders name attribute on div' do
      render_inline(Carbon::SelectableTileComponent.new(name: 'my-field')) { 'Content' }

      assert_selector 'div[name="my-field"]'
    end

    test 'renders value attribute on div' do
      render_inline(Carbon::SelectableTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector 'div[value="option1"]'
    end

    # -- Stimulus controller/values/actions --

    test 'renders stimulus controller' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector '[data-controller="carbon--selectable-tile"]'
    end

    test 'renders stimulus values' do
      render_inline(Carbon::SelectableTileComponent.new(selected: true, name: 'test', value: 'val1')) { 'Content' }

      assert_selector '[data-carbon--selectable-tile-selected-value="true"]'
      assert_selector '[data-carbon--selectable-tile-name-value="test"]'
      assert_selector '[data-carbon--selectable-tile-value-value="val1"]'
    end

    test 'renders stimulus actions on div' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      expected_action = 'click->carbon--selectable-tile#toggle ' \
                        'keydown->carbon--selectable-tile#handleKeydown'

      assert_selector "div[data-action=\"#{expected_action}\"]"
    end

    # -- Checkmark --

    test 'renders checkmark svg' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector '.cds--tile__checkmark svg'
    end

    test 'renders checkmark with persistent class' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector '.cds--tile__checkmark.cds--tile__checkmark--persistent'
    end

    test 'renders checkmark with aria-label when provided' do
      render_inline(Carbon::SelectableTileComponent.new(checkmark_label: 'Select this option')) { 'Content' }

      assert_selector '.cds--tile__checkmark span[aria-label="Select this option"]'
    end

    # -- Color scheme --

    test 'does not render color scheme class for default regular' do
      render_inline(Carbon::SelectableTileComponent.new(color_scheme: :regular)) { 'Content' }

      assert_selector 'div.cds--tile:not([class*="cds--tile--regular"])'
    end

    test 'renders light color scheme class' do
      render_inline(Carbon::SelectableTileComponent.new(color_scheme: :light)) { 'Content' }

      assert_selector 'div.cds--tile--light'
    end

    test 'raises error for invalid color scheme' do
      assert_raises(ArgumentError) do
        Carbon::SelectableTileComponent.new(color_scheme: :invalid)
      end
    end

    # -- AI label and rounded corners --

    test 'renders slug-rounded class when has_rounded_corners and ai_label' do
      component = Carbon::SelectableTileComponent.new(has_rounded_corners: true) { 'Content' }
      component.with_ai_label { 'AI' }
      render_inline(component)

      assert_selector 'div.cds--tile--slug-rounded'
    end

    test 'does not render slug-rounded class without ai_label' do
      render_inline(Carbon::SelectableTileComponent.new(has_rounded_corners: true)) { 'Content' }

      assert_no_selector 'div.cds--tile--slug-rounded'
    end

    test 'does not render slug-rounded class without has_rounded_corners' do
      component = Carbon::SelectableTileComponent.new(has_rounded_corners: false) { 'Content' }
      component.with_ai_label { 'AI' }
      render_inline(component)

      assert_no_selector 'div.cds--tile--slug-rounded'
    end

    # -- Slots --

    test 'renders decorator slot content' do
      component = Carbon::SelectableTileComponent.new { 'Content' }
      component.with_decorator { '<span class="decorator-test">Decorator</span>'.html_safe }
      render_inline(component)

      assert_selector '.decorator-test', text: 'Decorator'
    end

    test 'renders ai_label slot content' do
      component = Carbon::SelectableTileComponent.new { 'Content' }
      component.with_ai_label { '<span class="ai-label-test">AI Label</span>'.html_safe }
      render_inline(component)

      assert_selector '.ai-label-test', text: 'AI Label'
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::SelectableTileComponent.new(data: { test: 'value' })) { 'Content' }

      assert_selector 'div[data-test="value"]'
    end

    test 'passes through CSS classes' do
      render_inline(Carbon::SelectableTileComponent.new(class: 'custom-class')) { 'Content' }

      assert_selector 'div.custom-class.cds--tile'
    end
  end
end
