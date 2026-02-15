# frozen_string_literal: true

require 'test_helper'

module Carbon
  class DropdownComponentTest < CarbonViewComponents::TestCase
    # -- Default rendering --

    test 'renders default dropdown' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'div.cds--form-item'
      assert_selector 'div.cds--dropdown__wrapper.cds--list-box__wrapper'
      assert_selector 'div.cds--dropdown.cds--list-box'
    end

    test 'renders with stimulus controller' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector 'div[data-controller="carbon--dropdown"]'
    end

    test 'renders label' do
      render_inline(Carbon::DropdownComponent.new(label_text: 'Choose color')) do |c|
        c.with_item(value: 'red', text: 'Red')
      end

      assert_selector 'label.cds--label', text: 'Choose color'
    end

    test 'renders trigger button with combobox role' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Pick one')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button.cds--list-box__field[role="combobox"]'
      assert_selector 'button[aria-expanded="false"]'
      assert_selector 'button[aria-haspopup="listbox"]'
      assert_selector 'button[aria-label="Pick one"]'
    end

    test 'renders menu with listbox role' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'ul.cds--list-box__menu[role="listbox"]'
    end

    # -- Items --

    test 'renders items as option roles' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector 'li.cds--list-box__menu-item[role="option"]', count: 2
    end

    test 'renders item text' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'First Item')
      end

      assert_selector '.cds--list-box__menu-item__option', text: 'First Item'
    end

    test 'renders selected item with active class' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector 'li.cds--list-box__menu-item--active[aria-selected="true"]', count: 1
      assert_selector 'li[aria-selected="false"]', count: 1
    end

    test 'displays selected item text in trigger' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Pick')) do |c|
        c.with_item(value: 'opt1', text: 'Selected One', selected: true)
        c.with_item(value: 'opt2', text: 'Option 2')
      end

      assert_selector '.cds--list-box__label', text: 'Selected One'
    end

    test 'displays title_text when no item selected' do
      render_inline(Carbon::DropdownComponent.new(title_text: 'Choose')) do |c|
        c.with_item(value: 'opt1', text: 'Option 1')
      end

      assert_selector '.cds--list-box__label', text: 'Choose'
    end

    test 'renders checkmark icon for selected item' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Option 1', selected: true)
      end

      assert_selector '.cds--list-box__menu-item__selected-icon'
    end

    test 'renders disabled item' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'opt1', text: 'Disabled', disabled: true)
      end

      assert_selector 'li[aria-disabled="true"]'
    end

    # -- Sizes --

    test 'renders default md size' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--md'
    end

    test 'renders sm size' do
      render_inline(Carbon::DropdownComponent.new(size: :sm)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--sm'
    end

    test 'renders lg size' do
      render_inline(Carbon::DropdownComponent.new(size: :lg)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--lg'
    end

    # -- States --

    test 'renders disabled state' do
      render_inline(Carbon::DropdownComponent.new(disabled: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--disabled'
      assert_selector 'button[disabled]'
    end

    test 'renders invalid state' do
      render_inline(Carbon::DropdownComponent.new(invalid: true, invalid_text: 'Required')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--invalid'
      assert_selector '.cds--form-requirement', text: 'Required'
    end

    test 'renders warning state' do
      render_inline(Carbon::DropdownComponent.new(warn: true, warn_text: 'Careful')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown--warning'
      assert_selector '.cds--form-requirement', text: 'Careful'
    end

    test 'renders helper text' do
      render_inline(Carbon::DropdownComponent.new(helper_text: 'Pick something')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector '.cds--form__helper-text', text: 'Pick something'
    end

    # -- Label --

    test 'hides label when hide_label is true' do
      render_inline(Carbon::DropdownComponent.new(hide_label: true)) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'label.cds--visually-hidden'
    end

    # -- Stimulus data attributes --

    test 'renders trigger with stimulus target and action' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'button[data-carbon--dropdown-target="trigger"]'
      assert_selector 'button[data-action*="click->carbon--dropdown#toggle"]'
    end

    test 'renders menu with stimulus target' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'ul[data-carbon--dropdown-target="menu"]'
    end

    test 'renders items with stimulus target and action' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'li[data-carbon--dropdown-target="item"]'
      assert_selector 'li[data-action="click->carbon--dropdown#select"]'
    end

    # -- Menu icon --

    test 'renders chevron icon in trigger' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector '.cds--list-box__menu-icon svg'
    end

    # -- aria-controls --

    test 'trigger aria-controls matches menu id' do
      render_inline(Carbon::DropdownComponent.new) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      trigger = page.find('button[role="combobox"]')
      menu_id = trigger['aria-controls']

      assert_selector "ul##{menu_id}"
    end

    # -- Validation --

    test 'raises ArgumentError for invalid size' do
      assert_raises(ArgumentError) do
        Carbon::DropdownComponent.new(size: :xl)
      end
    end

    # -- System arguments --

    test 'passes through system arguments' do
      render_inline(Carbon::DropdownComponent.new(id: 'my-dropdown')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div#my-dropdown[data-controller="carbon--dropdown"]'
    end

    test 'merges custom class' do
      render_inline(Carbon::DropdownComponent.new(class: 'custom-dd')) do |c|
        c.with_item(value: 'a', text: 'A')
      end

      assert_selector 'div.cds--dropdown.custom-dd'
    end
  end
end
