# frozen_string_literal: true

require 'test_helper'

module Carbon
  class ComboBoxComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default combo box with stimulus controller' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector '.cds--form-item .cds--combo-box__wrapper'
      assert_selector '.cds--combo-box.cds--list-box'
      assert_selector '[data-controller="carbon--combo-box"]'
      assert_selector 'ul[role="listbox"]'
    end

    # -- Label --

    test 'renders label text' do
      render_inline(Carbon::ComboBoxComponent.new(label_text: 'Choose color')) do |c|
        c.with_item(value: 'red', text: 'Red')
      end

      assert_selector 'label.cds--label', text: 'Choose color'
    end

    test 'renders without label when not provided' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_no_selector 'label.cds--label'
    end

    # -- Input --

    test 'renders text input with placeholder and autocomplete attributes' do
      render_inline(Carbon::ComboBoxComponent.new(placeholder: 'Search...')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'input.cds--text-input[type="text"][placeholder="Search..."]'
      assert_selector 'input[autocomplete="off"][aria-autocomplete="list"]'
    end

    test 'renders default placeholder' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'input[placeholder="Filter..."]'
    end

    # -- Items --

    test 'renders items as list options with text' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
        c.with_item(value: 'opt3', text: 'Option 3')
      end

      assert_selector '.cds--list-box__menu-item[role="option"]', count: 3
      assert_selector '.cds--list-box__menu-item__option', text: 'Option 1'
    end

    test 'renders item with data attributes' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'my-val', text: 'My Value')
      end

      assert_selector '.cds--list-box__menu-item[data-value="my-val"][data-text="My Value"]'
    end

    test 'renders disabled items' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', disabled: true)
      end

      assert_selector '.cds--list-box__menu-item--disabled'
    end

    # -- Disabled --

    test 'renders disabled state with disabled input and label' do
      render_inline(Carbon::ComboBoxComponent.new(label_text: 'Label', disabled: true)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box--disabled'
      assert_selector 'input[disabled]'
      assert_selector 'label.cds--label.cds--label--disabled'
    end

    # -- Sizes --

    test 'renders default md size without extra class' do
      render_inline(Carbon::ComboBoxComponent.new(size: :md)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_no_selector '.cds--list-box--sm'
      assert_no_selector '.cds--list-box--lg'
    end

    test 'renders sm size' do
      render_inline(Carbon::ComboBoxComponent.new(size: :sm)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box--sm'
      assert_selector '.cds--combo-box--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::ComboBoxComponent.new(size: :lg)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box--lg'
      assert_selector '.cds--combo-box--lg'
    end

    # -- Validation states --

    test 'renders invalid state' do
      render_inline(Carbon::ComboBoxComponent.new(invalid: true, invalid_text: 'Required')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--combo-box--invalid'
      assert_selector '.cds--form-requirement', text: 'Required'
    end

    test 'renders warn state' do
      render_inline(Carbon::ComboBoxComponent.new(warn: true, warn_text: 'Check this')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--combo-box--warn'
      assert_selector '.cds--form-requirement', text: 'Check this'
    end

    test 'renders helper text' do
      render_inline(Carbon::ComboBoxComponent.new(helper_text: 'Pick an option')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--form__helper-text', text: 'Pick an option'
    end

    test 'does not render helper text when invalid' do
      render_inline(Carbon::ComboBoxComponent.new(
                      helper_text: 'Help', invalid: true, invalid_text: 'Error'
                    )) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_no_selector '.cds--form__helper-text'
      assert_selector '.cds--form-requirement', text: 'Error'
    end

    # -- ARIA --

    test 'field has combobox role with correct aria attributes' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      field = page.find('.cds--list-box__field[role="combobox"]')
      menu = page.find('ul.cds--list-box__menu')

      assert_equal 'false', field['aria-expanded']
      assert_equal 'listbox', field['aria-haspopup']
      assert_equal menu['id'], field['aria-controls']
    end

    test 'input has aria-controls pointing to menu' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      input = page.find('input.cds--text-input')
      menu = page.find('ul.cds--list-box__menu')

      assert_equal menu['id'], input['aria-controls']
    end

    # -- Clear button --

    test 'renders clear button hidden by default' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box__selection[style*="display: none"]', visible: :all
    end

    # -- Stimulus targets --

    test 'renders stimulus targets on field, menu, input, and items' do
      render_inline(Carbon::ComboBoxComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '[data-carbon--combo-box-target="field"]'
      assert_selector '[data-carbon--combo-box-target="menu"]'
      assert_selector '[data-carbon--combo-box-target="input"]'
      assert_selector '[data-carbon--combo-box-target="item"]'
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::ComboBoxComponent.new(size: :xl)
      end
    end
  end
end
