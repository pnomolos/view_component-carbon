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

    # -- CSS classes --

    test 'renders cds--tile--radio class' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector 'label.cds--tile--radio'
    end

    # -- Content wrapper --

    test 'renders content wrapper as div element' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector 'div.cds--tile-content', text: 'Content'
      assert_no_selector 'span.cds--tile-content'
    end

    # -- Color scheme --

    test 'renders regular color scheme by default' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_no_selector '.cds--tile--light'
    end

    test 'renders light color scheme' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', color_scheme: :light)) { 'Content' }

      assert_selector 'label.cds--tile--light'
    end

    test 'raises error for invalid color scheme' do
      assert_raises(ArgumentError) do
        Carbon::RadioTileComponent.new(value: 'option1', color_scheme: :invalid)
      end
    end

    # -- Checkmark label --

    test 'renders default checkmark label' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_selector '.cds--tile__checkmark svg title', text: 'Tile checkmark'
    end

    test 'renders custom checkmark label' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', checkmark_label: 'Custom label')) { 'Content' }

      assert_selector '.cds--tile__checkmark svg title', text: 'Custom label'
    end

    # -- Rounded corners --

    test 'does not render rounded corners by default' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1')) { 'Content' }

      assert_no_selector '.cds--tile--slug-rounded'
    end

    test 'renders rounded corners class when enabled' do
      render_inline(Carbon::RadioTileComponent.new(value: 'option1', has_rounded_corners: true)) { 'Content' }

      assert_selector 'label.cds--tile--slug-rounded'
    end
  end
end
