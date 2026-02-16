# frozen_string_literal: true

require 'test_helper'

module Carbon
  class SelectableTileComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default selectable tile' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector '.cds--tile.cds--tile--selectable'
    end

    test 'renders checkbox input' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'input[type="checkbox"].cds--tile-input'
    end

    test 'renders label with checkbox role' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'label[role="checkbox"]'
    end

    test 'renders content in tile-content span' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Selectable content' }

      assert_selector '.cds--tile-content', text: 'Selectable content'
    end

    # -- Selected state --

    test 'renders selected class when selected' do
      render_inline(Carbon::SelectableTileComponent.new(selected: true)) { 'Content' }

      assert_selector 'label.cds--tile--is-selected'
    end

    test 'renders aria-checked true when selected' do
      render_inline(Carbon::SelectableTileComponent.new(selected: true)) { 'Content' }

      assert_selector 'label[aria-checked="true"]'
    end

    test 'renders aria-checked false by default' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'label[aria-checked="false"]'
    end

    test 'renders checked checkbox when selected' do
      render_inline(Carbon::SelectableTileComponent.new(selected: true)) { 'Content' }

      assert_selector 'input[type="checkbox"][checked]'
    end

    # -- Disabled state --

    test 'renders disabled class when disabled' do
      render_inline(Carbon::SelectableTileComponent.new(disabled: true)) { 'Content' }

      assert_selector 'label.cds--tile--disabled'
    end

    test 'renders disabled checkbox when disabled' do
      render_inline(Carbon::SelectableTileComponent.new(disabled: true)) { 'Content' }

      assert_selector 'input[type="checkbox"][disabled]'
    end

    # -- Form attributes --

    test 'renders name attribute on input' do
      render_inline(Carbon::SelectableTileComponent.new(name: 'my-field')) { 'Content' }

      assert_selector 'input[name="my-field"]'
    end

    test 'renders value attribute on input' do
      render_inline(Carbon::SelectableTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector 'input[value="option1"]'
    end

    # -- Label association --

    test 'label for matches input id' do
      render_inline(Carbon::SelectableTileComponent.new(id: 'test-tile')) { 'Content' }

      assert_selector 'input#test-tile'
      assert_selector 'label[for="test-tile"]'
    end

    # -- Stimulus controller/target/action --

    test 'renders stimulus controller' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector '[data-controller="carbon--selectable-tile"]'
    end

    test 'renders stimulus targets' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector 'input[data-carbon--selectable-tile-target="input"]'
      assert_selector 'label[data-carbon--selectable-tile-target="label"]'
    end

    test 'renders stimulus actions on label' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      expected_action = 'click->carbon--selectable-tile#toggle ' \
                        'keydown->carbon--selectable-tile#handleKeydown'

      assert_selector "label[data-action=\"#{expected_action}\"]"
    end

    # -- Checkmark --

    test 'renders checkmark svg' do
      render_inline(Carbon::SelectableTileComponent.new) { 'Content' }

      assert_selector '.cds--tile__checkmark svg'
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::SelectableTileComponent.new(id: 'my-selectable')) { 'Content' }

      assert_selector 'input#my-selectable'
    end
  end
end
