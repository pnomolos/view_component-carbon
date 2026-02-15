# frozen_string_literal: true

require 'test_helper'

module Carbon
  class RadioTileComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default radio tile' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector '.cds--tile.cds--tile--selectable'
    end

    test 'renders radio input' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector 'input[type="radio"].cds--tile-input'
    end

    test 'renders content' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Radio content' }

      assert_selector '.cds--tile-content', text: 'Radio content'
    end

    # -- Checked state --

    test 'renders selected class when checked' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', checked: true)) { 'Content' }

      assert_selector 'label.cds--tile--is-selected'
    end

    test 'does not render selected class by default' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_no_selector '.cds--tile--is-selected'
    end

    # -- Disabled state --

    test 'renders disabled class when disabled' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', disabled: true)) { 'Content' }

      assert_selector 'label.cds--tile--disabled'
    end

    test 'renders disabled input when disabled' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', disabled: true)) { 'Content' }

      assert_selector 'input[type="radio"][disabled]'
    end

    # -- Form attributes --

    test 'renders name attribute on input' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', name: 'colors')) { 'Content' }

      assert_selector 'input[name="colors"]'
    end

    test 'renders value attribute on input' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector 'input[value="option1"]'
    end

    # -- Label association --

    test 'label for matches input id' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', id: 'test-radio')) { 'Content' }

      assert_selector 'input#test-radio'
      assert_selector 'label[for="test-radio"]'
    end

    # -- Checkmark --

    test 'renders checkmark svg' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector '.cds--tile__checkmark svg'
    end
  end
end
