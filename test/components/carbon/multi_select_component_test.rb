# frozen_string_literal: true

require 'test_helper'

module Carbon
  class MultiSelectComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default multi select with stimulus controller' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector '.cds--form-item .cds--multi-select__wrapper'
      assert_selector '.cds--multi-select.cds--list-box'
      assert_selector '[data-controller="carbon--multi-select"]'
      assert_selector 'ul[role="listbox"][aria-multiselectable="true"]'
    end

    # -- Label --

    test 'renders label text' do
      render_inline(Carbon::MultiSelectComponent.new(label_text: 'Choose colors')) do |c|
        c.with_item(value: 'red', text: 'Red')
      end

      assert_selector 'label.cds--label', text: 'Choose colors'
    end

    test 'renders without label when not provided' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_no_selector 'label.cds--label'
    end

    # -- Title text --

    test 'renders title text as trigger label' do
      render_inline(Carbon::MultiSelectComponent.new(title_text: 'Pick items')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box__label', text: 'Pick items'
    end

    test 'renders default title text' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box__label', text: 'Choose items'
    end

    # -- Items --

    test 'renders items as list options with checkbox labels' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
        c.with_item(value: 'opt3', text: 'Option 3')
      end

      assert_selector '.cds--list-box__menu-item[role="option"]', count: 3
      assert_selector '.cds--checkbox-label-text', text: 'Option 1'
    end

    test 'renders item with data-value attribute' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'my-val', text: 'My Value')
      end

      assert_selector '.cds--list-box__menu-item[data-value="my-val"]'
    end

    # -- Selected items --

    test 'renders selected items with active class and aria-selected' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector '.cds--list-box__menu-item--active[aria-selected="true"]', count: 1
      assert_selector '.cds--list-box__menu-item[aria-selected="false"]', count: 1
    end

    test 'renders selected count in trigger label' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
        c.with_item(value: 'opt2', text: 'Option 2', selected: true)
      end

      assert_selector '.cds--list-box__label', text: '2 items selected'
    end

    test 'renders singular item selected label' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
      end

      assert_selector '.cds--list-box__label', text: '1 item selected'
    end

    test 'renders clear button only when items are selected' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
      end

      assert_selector '.cds--list-box__selection.cds--tag--filter'
    end

    test 'does not render clear button when no items selected' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_no_selector '.cds--list-box__selection'
    end

    # -- Disabled --

    test 'renders disabled state with disabled button and label' do
      render_inline(Carbon::MultiSelectComponent.new(label_text: 'Label', disabled: true)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box--disabled'
      assert_selector 'button.cds--list-box__field[disabled]'
      assert_selector 'label.cds--label.cds--label--disabled'
    end

    test 'renders disabled items' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', disabled: true)
      end

      assert_selector '.cds--list-box__menu-item--disabled'
    end

    # -- Sizes --

    test 'renders default md size without extra class' do
      render_inline(Carbon::MultiSelectComponent.new(size: :md)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_no_selector '.cds--list-box--sm'
      assert_no_selector '.cds--list-box--lg'
    end

    test 'renders sm size' do
      render_inline(Carbon::MultiSelectComponent.new(size: :sm)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box--sm'
      assert_selector '.cds--multi-select--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::MultiSelectComponent.new(size: :lg)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box--lg'
      assert_selector '.cds--multi-select--lg'
    end

    # -- Validation states --

    test 'renders invalid state' do
      render_inline(Carbon::MultiSelectComponent.new(invalid: true, invalid_text: 'Required')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--multi-select--invalid'
      assert_selector '.cds--form-requirement', text: 'Required'
    end

    test 'renders warn state' do
      render_inline(Carbon::MultiSelectComponent.new(warn: true, warn_text: 'Check this')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--multi-select--warn'
      assert_selector '.cds--form-requirement', text: 'Check this'
    end

    test 'renders helper text' do
      render_inline(Carbon::MultiSelectComponent.new(helper_text: 'Pick one or more')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--form__helper-text', text: 'Pick one or more'
    end

    test 'does not render helper text when invalid' do
      render_inline(Carbon::MultiSelectComponent.new(
                      helper_text: 'Help', invalid: true, invalid_text: 'Error'
                    )) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_no_selector '.cds--form__helper-text'
      assert_selector '.cds--form-requirement', text: 'Error'
    end

    # -- Filterable --

    test 'renders filterable variant with input and combobox role' do
      render_inline(Carbon::MultiSelectComponent.new(filterable: true)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--multi-select--filterable'
      assert_selector 'input.cds--text-input[type="text"]'
      assert_selector '.cds--list-box__field[role="combobox"]'
    end

    test 'non-filterable has button trigger' do
      render_inline(Carbon::MultiSelectComponent.new(filterable: false)) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'button.cds--list-box__field'
    end

    # -- Stimulus targets --

    test 'renders stimulus targets on field, menu, and items' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '[data-carbon--multi-select-target="field"]'
      assert_selector '[data-carbon--multi-select-target="menu"]'
      assert_selector '[data-carbon--multi-select-target="item"]'
    end

    # -- ARIA --

    test 'trigger has correct aria attributes' do
      render_inline(Carbon::MultiSelectComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      trigger = page.find('button.cds--list-box__field')
      menu = page.find('ul.cds--list-box__menu')

      assert_equal 'false', trigger['aria-expanded']
      assert_equal 'listbox', trigger['aria-haspopup']
      assert_equal menu['id'], trigger['aria-controls']
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::MultiSelectComponent.new(size: :xl)
      end
    end
  end
end
